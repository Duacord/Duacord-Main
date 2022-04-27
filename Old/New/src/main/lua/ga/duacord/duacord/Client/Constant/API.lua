local API = {}

API.BASE_URL = "https://discord.com/"
API.API_VERSION = "9"
API.API_VERSION_PATH = string.format("v%s", API.API_VERSION)
API.API_URL = string.format("%sapi/%s", API.BASE_URL, API.API_VERSION_PATH)


return API