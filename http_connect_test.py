# encoding: utf-8
# !/usr/bin/env python3
"""
**使用Python3环境，且安装有requests三方库，可执行`pip install requests`命令进行安装**
"""
"""
1. 根据实际测试环境修改`http_connect_test.py`文件中的**IP、property**
2. _如需更换合成文件路径，修改`http_connect_test.py`文件中的**txt_path**_
3. 并发数由`http_connect_test.py`文件中的**thread_number**控制
4. 执行`http_connect_test.py`脚本，则会遍历**txt_path**中的所有**txt**文件进行合成，并将合成后的结果以同名wav的格式保存到**txt_path**中（如1.txt文件对应的合成文件为1.wav）
"""
import base64
import json
import os
import queue
import threading as td

import requests


def connect_test():
    while not file_queue.empty():
        print("Thread name is: " + td.current_thread().name)
        synth_txt_name = file_queue.get()
        synth_txt = open(txt_path + "/" + synth_txt_name, "r", encoding="utf-8").read()
        save_name = synth_txt_name.split(".")[0]
        # 获取新的token，生成header
        name_secret_base64 = base64.b64encode((APP_KEY + ":" + SECRET_KEY).encode("utf-8"))
        header = {'Authorization': b'Basic ' + name_secret_base64}
        body = {"appkey": APP_KEY}
        try:
            response = requests.get("https://{}:22801/v10/auth/get-access-token".format(IP), body, headers=header,
                                    verify=False)
            print(response)
        except Exception as e:
            print(e)
        else:
            token = json.loads(response.text)["token"]
            headers = {
                "Content-Type": 'application/json',
                "X-Hci-Access-Token": token
            }
            header = {
                "Content-Type": 'application/json',
                "X-Trace-Token": "xxx",
                # "X-Hci-Access-Token": "test"
                "X-Developer-Key": "xxx"
            }
            print(headers)

            body = {
                "text": synth_txt
            }
            body_json = json.dumps(body)
            url = "http://{}:22800/v10/tts/synth/{}/short_text?appkey=aicp_app".format(IP, property)
            print(url, "\n", "合成文件：" + synth_txt_name)
            response = requests.post(url, body_json, headers=headers)
            response.encoding = response.apparent_encoding
            response_body = response.content
            code = response.status_code
            coderesponse_headers = response.headers
            if code != 200:
                print(code, coderesponse_headers)
                print(response.text)

            if code == 200:
                # body形式返回保存音频方式
                audio_file = save_name + ".wav"
                with open(txt_path + "/" + audio_file, "wb") as f:
                    f.write(response_body)
            file_queue.task_done()

            # json格式返回保存音频方式
            # audio_data = json.loads(bytes.decode(response_body)).get("result").get("data")
            # # print(audio_data)
            # audio_file = property + ".wav"
            # with open(audio_file, "wb") as f:
            #     f.write(base64.b64decode(bytes(audio_data, encoding="utf8")))


if __name__ == "__main__":
    # 服务所在IP地址
    IP = "10.0.1.197"
    # 服务模型名称
    property = "cn_xinwenhan_common"
    APP_KEY = "aicp_app"
    SECRET_KEY = "QWxhZGRpbjpvcGVuIHNlc2FtZQ"
    # 并发数量
    thread_number = 3
    # 合成文本路径
    txt_path = r"./txt_files"
    # 创建一个队列
    file_queue = queue.Queue()
    filenames = os.listdir(txt_path)
    for filename in filenames:
        # 将文件名添加到队列
        if filename.split(".")[-1] == "txt":
            file_queue.put(filename)
    thread_list = []
    for i in range(thread_number):
        thread_name = 'http性能测试-' + str(i)
        new_thread = td.Thread(target=connect_test, args=(), name=f"Thread-{thread_name}")
        thread_list.append(new_thread)
        new_thread.start()
    for thread in thread_list:
        thread.join()
    file_queue.join()
