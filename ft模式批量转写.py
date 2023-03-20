# -*- coding:utf-8 -*-
# @author zhouwei
# @date 2023/3/1 14:19
# @file ft模式批量转写.py

"""
asr_ft 批量录音转写
音频文件的时长只能在一分钟之内
"""
import base64
import datetime
import json
import os
import time

import requests

# 请求地址
# base_url格式 ip:port
base_url = "www.callcent.chinaums.com"
# ASR模型
ASR_property = "cn_8k_common"
# 文件路径
file_path = "C:/Users/Maxzzz/Desktop/2-1录音/"
# 文本转写后的txt路径
transliteration_path = file_path + time.strftime("%Y-%m-%d") + ".txt"
# 获取token值
token = None


class RealTimeTranscription:

    def get_token(self):
        """
        获取token
        端口：22801
        """

        url = "https://" + base_url + "/v10/auth/get-access-token?appkey=aicp_app"
        payload = {}
        headers = {
            'Authorization': 'Basic YWljcF9hcHA6UVd4aFpHUnBianB2Y0dWdUlITmxjMkZ0WlE='}
        global token
        token = requests.request(
            "GET",
            url,
            headers=headers,
            data=payload,
            verify=False).json()['token']
        print("获取的token值：" + token)
        print("获取token的url：" + url)

    def transliteration_betys(self):
        """
        二进制流
        :return:
        """
        start_time = datetime.datetime.now()

        # 端口：22800
        url = "http://" + base_url + "/v10/asr/freetalk/" + \
              ASR_property + "/short_audio?appkey=aicp_app"
        print("transliteration_bytes中的token值：" + token)
        """
        @udioFormat 音频格式
        @addPunc= 是否输出标点
        @outputPInyin 是否输出拼音
        """
        headers = {
            'X-Hci-Access-Token': token,
            'X-AICloud-Config': 'audioFormat=auto,addPunc=true,outputPInyin=False',
            'Content-Type': 'application/octet-stream'}

        """
        读取指定目录下的文件，并将文件名和转写后的文本写入txt文本中
        """
        path_list = os.listdir(file_path)
        path_name = []
        for name in path_list:
            path_name.append(name)
        # 判断文件是否存在，存在则删除
        if os.path.exists(transliteration_path):
            os.remove(transliteration_path)
            """
            file_name：录音文件名
            """
        success = 0
        error = 0
        for file_name in path_name:
            with open(transliteration_path, "a") as file:
                # print("transliteration_path:" + transliteration_path)
                # 判断该目录下的是否为wav的文件格式
                if os.path.splitext(file_name)[-1] == ".wav":
                    payload = open(file_path + file_name, "rb").read()
                    response = requests.request(
                        "POST",
                        url,
                        headers=headers,
                        data=payload)
                    print(response.json())
                    file.writelines(file_name + "\t")
                    """
                    如果音频时长超过一分钟，则跳过该音频文件，执行下一个音频
                    """
                    try:
                        file.writelines(
                            response.json()['result']['text'] + "\n")
                        success = success + 1
                    except Exception:
                        file.writelines("ERROR：音频文件时长超过一分钟，无法转写" + "\n")
                        error = error + 1
                        continue
                file.close()
        end_time = datetime.datetime.now()
        print(f'转写耗时：{(end_time - start_time).seconds}')
        with open(transliteration_path, "a") as file:
            file.writelines("本次转写文件：" + str(success + error) + "个" + "\n")
            file.writelines("成功：" + str(success) + "个" + "\n")
            file.writelines("失败：" + str(error) + "个" + "\n")
            file.writelines(
                "本次转写共耗时：" + str((end_time - start_time).seconds) + "秒" + "\n")
        file.close()

    def transliteration_json(self):
        start_time = datetime.datetime.now()
        """
        json格式
        :return:
        """
        success = 0
        error = 0
        # 端口：22800
        url = "http://" + base_url + "/v10/asr/freetalk/" + \
              ASR_property + "/short_audio?appkey=aicp_app"
        print("transliteration_json中的token值：" + token)
        headers = {
            'X-Hci-Access-Token': token,
            'Content-Type': 'application/json'
        }

        """
        读取指定目录下的文件，并将文件名和转写后的文本写入txt文本中
        """
        path_list = os.listdir(file_path)
        path_name = []
        for name in path_list:
            path_name.append(name)
        # 判断文件是否存在，存在则删除
        if os.path.exists(transliteration_path):
            os.remove(transliteration_path)
            """
            file_name：录音文件名
            """
        for file_name in path_name:
            with open(transliteration_path, "a") as file:
                # 判断该目录下的是否为wav的文件格式
                if os.path.splitext(file_name)[-1] == ".wav":
                    """
                    1、使用 rb 模式打开音频文件
                    2、使用 read() 读取录音文件中的内容
                    3、通过解密为 utf-8 的格式
                    """
                    audio_file = base64.b64encode(
                        open(file_path + file_name, "rb").read()).decode("UTF-8")
                    # 将 str 类型的 audio_file 组装成字典类型
                    audio_data = {
                        "config": {
                            "audioFormat": "auto",
                            "addPunc": True},
                        "audio": audio_file}
                    # 转换 dict 类型的 audio_data 为 json 格式
                    payload = json.dumps(audio_data)
                    response = requests.request(
                        "POST", url, headers=headers, data=payload)
                    print(response.json())
                    file.writelines(file_name + "\t")
                    """
                    如果音频时长超过一分钟，则跳过该音频文件，执行下一个音频
                    """
                    try:
                        file.writelines(
                            response.json()['result']['text'] + "\n")
                        success = success + 1
                    except Exception:
                        file.writelines("ERROR：音频文件时长超过一分钟，无法转写" + "\n")
                        error = error + 1
                    continue
                file.close()
        end_time = datetime.datetime.now()
        print(f'转写耗时：{(end_time - start_time).seconds}')
        with open(transliteration_path, "a") as file:
            file.writelines("本次转写文件：" + str(success + error) + "个" + "\n")
            file.writelines("成功：" + str(success) + "个" + "\n")
            file.writelines("失败：" + str(error) + "个" + "\n")
            file.writelines(
                "本次转写共耗时：" + str((end_time - start_time).seconds) + "秒" + "\n")
        file.close()


if __name__ == '__main__':
    asr = RealTimeTranscription()
    asr.get_token()
    asr.transliteration_betys()
    # asr.transliteration_json()
