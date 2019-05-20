import requests

headers = {
    "X-DB-Auth": 'whatsmydbauth'
}
url = "https://pandora.sumsc.xin/inspect"

if __name__ == "__main__":
    res = requests.post(url, headers=headers).json()
    with open('id_all.txt', 'w', encoding='utf8') as fp:
        fp.writelines([str(i.get("id_tag", ' ')) + ' ' + str(i.get("repo", ' ')) + '\n' for i in res])
