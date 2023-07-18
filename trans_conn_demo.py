#!/usr/bin/env python3
# encoding: utf-8
'''
@author: baiganggang
@file: trans_conn_demo.py
@time: 2020/11/23 15:04
trans测试脚本
'''
import base64
import json
import os
import time

import requests

# 忽略requests请求的警告信息
requests.packages.urllib3.disable_warnings()
# 服务器地址
URL = "yyt.pointlinkpro.com"

Header = {"Content-Type": 'application/json'}

# file_x = "http://10.0.0.249:8083/1.wav"
# file_x = "http://10.0.0.249:8083/0914267.V3"
# file_x = "http://10.0.0.249:8083/emo.wav"

# file_x = "http://172.17.1.5:33080/files/15-1503-150302-X1vdPH-100012-2023061408220120230614085109.mp3"  # 问题录音
file_x = "http://172.17.1.5:33080/files/h.mp3"

# 噪声录音
# file_x = "http://172.17.1.5:33080/files
# /prd_4c8c14394679446cae6791231941bd47_upload_2023_06_15_12_4c8c14394679446cae6791231941bd47_00201_ccl002_2023061512042020230615120520.mp3"
# file_x = "http://172.17.1.5:33080/files
# /prd_4c8c14394679446cae6791231941bd47_upload_2023_06_25_16_4c8c14394679446cae6791231941bd47_00201_ccl002_2023062516384220230625164837.mp3"
file_size = str(88975920000)


# 获取token接口
def get_token():
    name_secret = "aicp_app:QWxhZGRpbjpvcGVuIHNlc2FtZQ"
    name_secret_base64 = base64.b64encode(name_secret.encode("utf-8"))
    header = {'Authorization': b'Basic ' + name_secret_base64}
    body = {"appkey": "aicp_app"}
    url_all = "https://" + URL + ":8446/v10/auth/get-access-token"
    try:
        response = requests.get(url_all, body, headers=header, verify=False)
    except Exception as e:
        print(response.text)
        print(e)
    else:
        print("token是：", response.text, "\n\n")

        # global header_s
        return json.loads(response.text)["token"]


def common_api(method, uri, json_data, header=Header):
    url_all = "https://" + URL + ":8446" + uri
    print("{}方式，请求url为：{}".format(method, url_all))
    print("请求body信息：", json_data)
    print("请求的header信息是：", header)
    start_time = time.time()
    resp = requests.request(method, url_all, headers=header, json=json_data)
    if str(resp.headers).find('zip') != -1:
        resp_body = resp.content
    else:
        resp_body = resp.text
    time_all = time.time() - start_time
    print("响应耗时：", time_all)
    print("响应状态码：", resp.status_code)
    return time_all, resp_body


# 列出支持的property
def trans_test_list_properties(header):
    req_uri = "/v10/asr/trans/list_properties?appkey=aicp_app"
    # print(self.headers)
    try:
        time_all, response_body = common_api("get", req_uri, "", header)
    except Exception as e:
        print(e)
    else:
        print("响应信息：", response_body)
        return response_body


# 分析接口，并把某个请求对象的task_id记录在公共的self.task_id中
def trans_test_submit(property, header):
    req_uri = "/v10/asr/trans/" + property + "/submit?appkey=aicp_app"
    # 请求json串
    json_data = {
        "files": [file_x],
        # "folder": {
        #    "paths": ["http://172.17.1.5:33080/files/20230626"],
        #     # 录音实际路径
        #     "paths": ["/home/hcicloud/tarball/audios/"],
        #     # 文件后缀
        # "exts": [".mp3", ".v3"],
        # },
        "priority": 0,
        # 根据实际音频格式来进行设置，支持pcm_s16le_16k，pcm_s16le_8k，alaw_16k，alaw_8k，ulaw_16k，ulaw_8k，vox_8k，vox_6k，auto
        "audioFormat": "auto",
        # "audioFormat": "auto",
        # "channelCount": 1,
        # "saveTo": {
        #     # 保证该目录存在且有读写权限
        #     "path": "ftp://10.0.0.148:21/upload",
        #     # "path": "file:///home/baiganggang/trans/result",
        #     "style": "name",
        # },
        # "outputPinyin": True,
        "resultType": "JSON",
        # "resultType": "TXT",
        # "words": {
        #     "type": "WORD",
        #     "tpp": True,
        # },
        # "vocab": "大歌 [da4 ge1]",
        "sa": {
            # "diarization": True,
            # "checkEmotion": True,
            # "outputVolume": True,
            # "outputSpeed": True,
            "checkRole": True,
            # "channelRole": "LEFT_AGENT",
            "outputSilence": True,
        },
        "tpp": {
            # "puncWeight": 100,
            "textSmooth": True,  # 文本顺滑
            #   "wordFilter": True,
            "addPunc": True,
            "digitNorm": True  # 数字归一化
            #   "makeParagraph": True,
        }
    }
    try:
        time_all, response_body = common_api("post", req_uri, json_data, header)
    except Exception as e:
        print(e)
    else:
        print("响应信息：", response_body)
        try:
            task_id = json.loads(response_body)["taskId"]
            return task_id
        except Exception as e:
            print(e)


# 任务查询
def trans_test_query(property, header, task_id):
    req_uri = "/v10/asr/trans/" + property + "/query?appkey=aicp_app&task={}".format(task_id)
    try:
        time_all, response_body = common_api("get", req_uri, "", header)
    except Exception as e:
        print(e)
    else:
        print("响应信息：", response_body)
        return response_body


# Todo
# 准备上传
def trans_prepare_download(property, header):
    req_uri = "/v10/asr/trans/" + property + "/prepare_upload?appkey=aicp_app"

    json_data = {}
    file_name = os.path.split(file_x)[-1]
    # json_data["name"] = file_name
    json_data["name"] = "test123.mp3"
    json_data["size"] = file_size
    try:
        time_all, response_body = common_api("post", req_uri, json_data, header)
    except Exception as e:
        print(e)
    else:
        print("响应信息：", response_body)
        try:
            response_dict = json.loads(response_body)
            return response_dict
        except Exception as e:
            print(e)


# 结果下载
def trans_test_download(property, header, task_id):
    req_uri = "/v10/asr/trans/" + property + "/download?appkey=aicp_app&task={}&files=0.json".format(task_id)
    try:
        time_all, response_body = common_api("get", req_uri, "", header)
    except Exception as e:
        print(e)
    else:
        if str(response_body).startswith("{"):
            print(str(response_body))
        else:
            # with open('C:/Users/Maxzzz/Desktop/result/20230627/' + task_id + '.txt', 'wb+') as result:
            with open('C:/Users/Maxzzz/Desktop/result/20230627/' + task_id + '_' + str(time.time()) +
                      '.txt',
                      'wb+') as result:
                try:
                    result.write(response_body.encode())
                except Exception as e:
                    result.write(response_body)
                print("转写结果已下载至本地：" + task_id + '.txt')
        return response_body


if __name__ == '__main__':
    token = get_token()
    Header["X-Hci-Access-Token"] = token
    start_time = time.time()
    list_properties_resp = trans_test_list_properties(Header)
    print("\n")
    property = json.loads(list_properties_resp)["properties"][1]
    prepare_upload_result = trans_prepare_download(property=property, header=Header)
    print(prepare_upload_result)
    task_id = trans_test_submit(property, Header)
    print("\n")
    response_body = trans_test_query(property, Header, task_id)
    print("#####################" + "\n" + response_body)
    query_isfinished_stutas = json.loads(response_body)["finished"]
    while True:
        print("是否转写完成：", query_isfinished_stutas, "\n")
        if query_isfinished_stutas is True:
            duration = 0
            for file_data in json.loads(response_body)["files"]:
                start = file_data['startTime']
                duration += file_data['duration']
            print("处理音频时长: ", duration / 1000)
            break
        else:
            time.sleep(2)
            response_body = trans_test_query(property, Header, task_id)
            query_isfinished_stutas = json.loads(response_body)["finished"]
    print("处理时间：", time.time() - start_time)
    trans_test_download(property, Header, task_id)
