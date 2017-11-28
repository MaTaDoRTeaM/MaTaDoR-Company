dofile('./Config.lua')
json = dofile('./libs/JSON.lua')
serpent = dofile("./libs/serpent.lua")
lgi = require ('lgi')
notify = lgi.require('Notify')
notify.init ("Telegram updates")
redis =  dofile("./libs/redis.lua")
http = require "socket.http"
utf8 = dofile('./libs/utf8.lua')
djson = dofile('./libs/dkjson.lua')
http = require("socket.http")
https = require("ssl.https")
URL = require("socket.url")
https = require "ssl.https"
minute = 60
hour = 3600
day = 86400
week = 604800
MsgTime = os.time() - 60
local senspost = {
  cappost = 70,
  cappostwithtag = 50,
  textpost = 200,
  textpostwithtag = 130
}
local color = {
  black = {30, 40},
  red = {31, 41},
  green = {32, 42},
  yellow = {33, 43},
  blue = {34, 44},
  magenta = {35, 45},
  cyan = {36, 46},
  white = {37, 47}
}
function justsudo(msg)
local var = false
if Sud0 == tonumber(msg.sender_user_id) then
var = true
end
return var
end
local function getParse(parse_mode)
local P = {}
if parse_mode then
local mode = parse_mode:lower()
if mode == 'markdown' or mode == 'md' then
P._ = 'textParseModeMarkdown'
elseif mode == 'html' then
P._ = 'textParseModeHTML'
end
end
return P
end
function is_sudo(msg)
local var = false
for v,user in pairs(SUDO_ID) do
if user == msg.sender_user_id then
var = true
end
end
if redis:sismember("SUDO-ID", msg.sender_user_id) then
var = true
end
if Sud0 == tonumber(msg.sender_user_id) then
var = true
end
return var
end
function is_Fullsudo(msg)
local var = false
for v,user in pairs(Full_Sudo) do
if user == msg.sender_user_id then
var = true
end
end
return var 
end
function do_notify (user, msg)
local n = notify.Notification.new(user, msg)
n:show ()
end

function is_GlobalyBan(user_id)
local var = false
local hash = 'GlobalyBanned:'
local gbanned = redis:sismember(hash, user_id)
if gbanned then
var = true
end
return var
end
-- Owner Msg
function is_Owner(msg) 
local hash = redis:sismember('OwnerList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or justsudo(msg) then
return true
else
return false
end
end
-----MaTaDoR Company
function is_Mod(msg) 
  local hash = redis:sismember('ModList:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) or justsudo(msg) then
return true
else
return false
end
end
function is_Vip(msg) 
local hash = redis:sismember('Vip:'..msg.chat_id,msg.sender_user_id)
if hash or is_sudo(msg) or is_Owner(msg) or is_Mod(msg) or justsudo(msg) then
return true
else
return false
end
end
function is_Banned(chat_id,user_id)
local hash =  redis:sismember('BanUser:'..chat_id,user_id)
if hash then
return true
else
return false
end
end
function private(chat_id,user_id)
local Mod = redis:sismember('ModList:'..chat_id,user_id)
local Vip = redis:sismember('Vip:'..chat_id,user_id)
local Owner = redis:sismember('OwnerList:'..chat_id,user_id)
if tonumber(user_id) == tonumber(TD_ID) or Owner or Mod or Vip then
return true
else
return false
end
end
function is_filter(msg,value)
local list = redis:smembers('Filters:'..msg.chat_id)
var = false
for i=1, #list do
if value:match(list[i]) then
var = true
end
end
return var
end
function is_MuteUser(chat_id,user_id)
local hash =  redis:sismember('MuteUser:'..chat_id,user_id)
if hash then
return true
else
return false
end
end
function ec_name(name) 
matches = name
if matches then
if matches:match('_') then
matches = matches:gsub('_','')
end
if matches:match('*') then
matches = matches:gsub('*','')
end
if matches:match('`') then
matches = matches:gsub('`','')
end
return matches
end
end
function check_markdown(text)
str = text
if str:match('_') then
output = str:gsub('_',[[\_]])
elseif str:match('*') then
output = str:gsub('*','\\*')
elseif str:match('`') then
output = str:gsub('`','\\`')
else
output = str
end
return output
end
function sendText(chat_id,msg,text, parse)
assert( tdbot_function ({
_ = "sendMessage",chat_id = chat_id,
reply_to_message_id = msg,
disable_notification = 0,
from_background = 1,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",text = text,
disable_web_page_preview = 1,
clear_draft = 0,
parse_mode = getParse(parse),
entities = {}
}
}, dl_cb, nil))
end

local function getChatId(chat_id)
local chat = {}
local chat_id = tostring(chat_id)
if chat_id:match('^-100') then
local channel_id = chat_id:gsub('-100', '')
chat = {id = channel_id, type = 'channel'}
else
local group_id = chat_id:gsub('-', '')
chat = {id = group_id, type = 'group'}
end
return chat
end
function Td_boT(chat_id,msg,text, parse)
assert( tdbot_function ({
_ = "sendMessage",chat_id = chat_id,
reply_to_message_id = msg,
disable_notification = 0,
from_background = 1,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",text = text,
disable_web_page_preview = 1,
clear_draft = 0,
parse_mode = getParse(parse),
entities = {}
}
}, dl_cb, nil))
end
local function getMe(cb)
assert (tdbot_function ({
_ = "getMe",
}, cb, nil))
end
function Pin(channelid,messageid,disablenotification)
assert (tdbot_function ({
_ = "pinChannelMessage",
channel_id = getChatId(channelid).id,
message_id = messageid,
disable_notification = disablenotification
}, dl_cb, nil))
end
function Unpin(channelid)
assert (tdbot_function ({
_ = 'unpinChannelMessage',
channel_id = getChatId(channelid).id
}, dl_cb, nil))
end
function KickUser(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusBanned"
},
}, dl_cb, nil)
end
function getFile(fileid,cb)
assert (tdbot_function ({
_ = 'getFile',
file_id = fileid
}, cb, nil))
end

function Left(chat_id, user_id, s)
assert (tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatus" ..s
},
}, dl_cb, nil))
end
function changeDes(MaTaDoR,Company)
assert (tdbot_function ({
_ = 'changeChannelDescription',
channel_id = getChatId(MaTaDoR).id,
description = Company
}, dl_cb, nil))
end
function changeChatTitle(chat_id, title)
assert (tdbot_function ({
_ = "changeChatTitle",
chat_id = chat_id,
title = title
}, dl_cb, nil))
end

function mute(chat_id, user_id, Restricted, right)
local chat_member_status = {}
if Restricted == 'Restricted' then
chat_member_status = {
is_member = right[1] or 1,
restricted_until_date = right[2] or 0,
can_send_messages = right[3] or 1,
can_send_media_messages = right[4] or 1,
can_send_other_messages = right[5] or 1,
can_add_web_page_previews = right[6] or 1
}
chat_member_status._ = 'chatMemberStatus' .. Restricted
assert (tdbot_function ({
_ = 'changeChatMemberStatus',
chat_id = chat_id,
user_id = user_id,
status = chat_member_status
}, dl_cb, nil))
end
end
function promoteToAdmin(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusAdministrator"
},
}, dl_cb, nil)
end
function resolve_username(username,cb)
tdbot_function ({
_ = "searchPublicChat",
username = username
}, cb, nil)
end
function RemoveFromBanList(chat_id, user_id)
tdbot_function ({
_ = "changeChatMemberStatus",
chat_id = chat_id,
user_id = user_id,
status = {
_ = "chatMemberStatusLeft"
},
}, dl_cb, nil)
end

function getChatHistory(chat_id, from_message_id, offset, limit,cb)
tdbot_function ({
_ = "getChatHistory",
chat_id = chat_id,
from_message_id = from_message_id,
offset = offset,
limit = limit
}, cb, nil)
end
function deleteMessagesFromUser(chat_id, user_id)
tdbot_function ({
_ = "deleteMessagesFromUser",
chat_id = chat_id,
user_id = user_id
}, dl_cb, nil)
end
function deleteMessages(chat_id, message_ids)
tdbot_function ({
_= "deleteMessages",
chat_id = chat_id,
message_ids = message_ids -- vector {[0] = id} or {id1, id2, id3, [0] = id}
}, dl_cb, nil)
end
local function getMessage(chat_id, message_id,cb)
tdbot_function ({
_ = "getMessage",
chat_id = chat_id,
message_id = message_id
}, cb, nil)
end
 function GetChat(chatid,cb)
assert (tdbot_function ({
_ = 'getChat',
chat_id = chatid
}, cb, nil))
end
function sendInline(chatid, replytomessageid, disablenotification, frombackground, queryid, resultid)
assert (tdbot_function ({
_ = 'sendInlineQueryResultMessage',
chat_id = chatid,
reply_to_message_id = replytomessageid,
disable_notification = disablenotification,
from_background = frombackground,
query_id = queryid,
result_id = tostring(resultid)
}, dl_cb,nil))
end
function get(bot_user_id, chat_id, latitude, longitude, query,offset, cb)
  assert (tdbot_function ({
_ = 'getInlineQueryResults',
 bot_user_id = bot_user_id,
chat_id = chat_id,
user_location = {
 _ = 'location',
latitude = latitude,
longitude = longitude 
},
query = tostring(query),
offset = tostring(off)
}, cb, nil))
end
function  viewMessages(chat_id, message_ids)
tdbot_function ({
_ = "viewMessages",
chat_id = chat_id,
message_ids = message_ids
}, dl_cb, nil)
end
local function getInputFile(file, conversion_str, expectedsize)
local input = tostring(file)
local infile = {}
if (conversion_str and expectedsize) then
infile = {
_ = 'inputFileGenerated',
original_path = tostring(file),
conversion = tostring(conversion_str),
expected_size = expectedsize
}
else
if input:match('/') then
infile = {_ = 'inputFileLocal', path = file}
elseif input:match('^%d+$') then
infile = {_ = 'inputFileId', id = file}
else
infile = {_ = 'inputFilePersistentId', persistent_id = file}
end
end
return infile
end
function addChatMembers(chatid, userids)
assert (tdbot_function ({
_ = 'addChatMembers',
chat_id = chatid,
user_ids = userids,
},  dl_cb, nil))
end
function GetChannelFull(channelid)
assert (tdbot_function ({
 _ = 'getChannelFull',
channel_id = getChatId(channelid).id
}, cb, nil))
end
function sendGame(chat_id, reply_to_message_id, botuserid, gameshortname, disable_notification, from_background, reply_markup)
local input_message_content = {
_ = 'inputMessageGame',
bot_user_id = botuserid,
game_short_name = tostring(gameshortname)
}
sendMessage(chat_id, reply_to_message_id, input_message_content, disable_notification, from_background, reply_markup)
end
function SendMetin(chat_id, user_id, msg_id, text, offset, length)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = false,
entities = {[0] = {
offset = offset,
length = length,
_ = "textEntity",
type = {
user_id = user_id,
 _ = "textEntityTypeMentionName"}
}
}
}
}, dl_cb, nil))
end
local function edit(chat_id, message_id, text,length,user_id)
tdbot_function ({
_ = "editMessageText",
chat_id = chat_id,
message_id = message_id,
reply_markup= 0, -- reply_markup:ReplyMarkup
input_message_content = {
_= "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = 0,
entities = {[0] = {
offset = 0,
length = length,
_ = "textEntity",
type = {
user_id = user_id,
 _ = "textEntityTypeMentionName"}
}
}
}
}, dl_cb, nil)
end
function sendDocument(chat_id, reply_to_message_id,disable_notification,from_background ,reply_markup,document)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = 'inputMessageDocument',
document = getInputFile(document),
},
}, dl_cb, nil))
end
function changeChatPhoto(chat_id,photo)
assert (tdbot_function ({
_ = 'changeChatPhoto',
chat_id = chat_id,
photo = getInputFile(photo)
}, dl_cb, nil))
end
function getFile(fileid)
assert (tdbot_function ({
_ = 'getFile',
file_id = fileid
},dl_cb,nil))
end
function GetWeb(messagetext,cb)
assert (tdbot_function ({
_ = 'getWebPagePreview',
message_text = tostring(messagetext)
}, cb, nil))
end
function downloadFile(fileid)
assert (tdbot_function ({
_ = 'downloadFile',
file_id = fileid,
},  dl_cb, nil))
end
local function sendMessage(c, e, r, n, e, r, callback, data)
assert (tdbot_function ({
_ = 'sendMessage',
chat_id = c,
reply_to_message_id =e,
disable_notification = r or 0,
from_background = n or 1,
reply_markup = e,
input_message_content = r
}, callback or dl_cb, data))
end
local function sendPhoto(chat_id, reply_to_message_id, disable_notification, from_background, reply_markup, photo, caption)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = "inputMessagePhoto",
photo = getInputFile(photo),
added_sticker_file_ids = {},
width = 0,
height = 0,
caption = caption
},
}, dl_cb, nil))
end
function GetUser(user_id, cb)
assert (tdbot_function ({
_ = 'getUser',
user_id = user_id
}, cb, nil))
end
local function GetUserFull(user_id,cb)
assert (tdbot_function ({
_ = "getUserFull",
user_id = user_id
}, cb, nil))
end
function file_exists(name)
local f = io.open(name,"r")
if f ~= nil then
io.close(f)
return true
else
return false
end
end
function getChannelFull(MaTaDoR,Company)
assert (tdbot_function ({
_ = 'getChannelFull',
channel_id = getChatId(MaTaDoR).id
}, Company, nil))
end
function setProfilePhoto(photo_path)
assert (tdbot_function ({
_ = 'setProfilePhoto',
photo = photo_path
},  dl_cb, nil))
end
function ForMsg(chat_id, from_chat_id, message_id,from_background)
assert (tdbot_function ({
_ = "forwardMessages",
chat_id = chat_id,
from_chat_id = from_chat_id,
message_ids = message_id,
disable_notification = 0,
from_background = from_background
}, dl_cb, nil))
end
function getChannelMembers(channelid,mbrfilter,off, limit,cb)
if not limit or limit > 2000000000 then
limit = 2000000000 
end  
assert (tdbot_function ({
_ = 'getChannelMembers',
channel_id = getChatId(channelid).id,
filter = {
_ = 'channelMembersFilter' .. mbrfilter,
},
offset = off,
limit = limit
}, cb, nil))
end
function sendVideoNote(chat_id, reply_to_message_id,disable_notification,from_background ,reply_markup,videonote, vnote_thumb, vnote_duration, vnote_length)
assert (tdbot_function ({
_= "sendMessage",
chat_id = chat_id,
reply_to_message_id = reply_to_message_id,
disable_notification = disable_notification,
from_background = from_background,
reply_markup = reply_markup,
input_message_content = {
_ = 'inputMessageVideoNote',
video_note = getInputFile(videonote),
},
}, dl_cb, nil))
end
function sendGame(chat_id, msg_id, botuserid, gameshortname)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = 'inputMessageGame',
bot_user_id = botuserid,
game_short_name = tostring(gameshortname)
}
}, dl_cb, nil))
end
function file_exists(name)
local f = io.open(name,"r")
if f ~= nil then
io.close(f)
return true
else
return false
end
end
function SendMetion(chat_id, user_id, msg_id, text, offset, length)
assert (tdbot_function ({
_ = "sendMessage",
chat_id = chat_id,
reply_to_message_id = msg_id,
disable_notification = 0,
from_background = true,
reply_markup = nil,
input_message_content = {
_ = "inputMessageText",
text = text,
disable_web_page_preview = 1,
clear_draft = false,
entities = {[0] = {
offset =  offset,
length = length,
_ = "textEntity",
type = {user_id = user_id, _ = "textEntityTypeMentionName"}}}
}
}, dl_cb, nil))
end
function dl_cb(arg, data)
end
function is_supergroup(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if not msg.is_post then
return true
end
else
return false
end
end
dofile('./libs/utf8.lua')
function showedit(msg,data)
if msg then
local TD_B0T = msg.content.text
if TD_B0T then
TD_B0T = TD_B0T:lower()
end
 if MsgType == 'text' and TD_B0T then
if TD_B0T:match('^[/#!]') then
TD_B0T= TD_B0T:gsub('^[/#!]','')
end
end
if msg.date < tonumber(MsgTime) then
print('OLD MESSAGE')
return false
end
if is_supergroup(msg) then
if TD_B0T == TDBT or TD_B0T == TDB0 then if is_Mod(msg) then Td_boT(msg.chat_id, msg.id,redis_hetd_bot,'md') else Td_boT(msg.chat_id, msg.id,redis_hetd_unmod,'md') end end
if not is_sudo(msg) then
if not redis:sismember('CompanyAll',msg.chat_id) then
redis:sadd('CompanyAll',msg.chat_id)
redis:set("ExpireData:"..msg.chat_id,'w')
else
if redis:get("ExpireData:"..msg.chat_id) then
if redis:ttl("ExpireData:"..msg.chat_id) and tonumber(redis:ttl("ExpireData:"..msg.chat_id)) < 432000 and not redis:get('CheckExpire:'..msg.chat_id) then
end
redis:set('CheckExpire:'..msg.chat_id,true)
elseif not redis:get("ExpireData:"..msg.chat_id) then
sendText(msg.chat_id,0,"⇜شارژ  "..msg.chat_id.." این گروه به اتمام رسیده است لطفا به مدیر ربات مراجعه کنید","md")
local Link = redis:get('Link:'..msg.chat_id) or 'ثبت نشده'
local textt =[[ شارز گروه زیر به اتمام رسیده است 

شناسه گروه : ]]..msg.chat_id..[[


لینگ گروه : ]]..Link..[[
]]

sendText(Sudoid,0,textt,'md')
print(Link)
redis:del("OwnerList:",msg.chat_id)
redis:del("ModList:",msg.chat_id)
redis:del("Filters:",msg.chat_id)
redis:del("MuteList:",msg.chat_id)
Left(msg.chat_id,TD_ID, "Left")
end       
end
end
end
if is_Owner(msg) then
if msg.content._ == 'messagePinMessage' then
print '      Pinned By Owner       '
redis:set('Pin_id'..msg.chat_id, msg.content.message_id)
end
end
NUM_MSG_MAX = 6
if redis:get('Flood:Max:'..msg.chat_id) then
NUM_MSG_MAX = redis:get('Flood:Max:'..msg.chat_id)
end
NUM_CH_MAX = 200
if redis:get('NUM_CH_MAX:'..msg.chat_id) then
NUM_CH_MAX = redis:get('NUM_CH_MAX:'..msg.chat_id)
end
TIME_CHECK = 2
if redis:get('Flood:Time:'..msg.chat_id) then
TIME_CHECK = redis:get('Flood:Time:'..msg.chat_id)
end
warn = 5
if redis:get('Warn:Max:'..msg.chat_id) then
warn = redis:get('Warn:Max:'..msg.chat_id)
end
if is_supergroup(msg) then
--------Flood Check------------⇜
function antifloodstats(msg,status)
if status == "kickuser" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
return true
end
SendMetion(msg.chat_id,msg.sender_user_id, msg.id, '⇜ کاربر : '..msg.sender_user_id..' به علت ارسال بیش از حد پیام  از گروه اخراج شد', 10,string.len(msg.sender_user_id))
KickUser(msg.chat_id,msg.sender_user_id)
end
if status == "deletemsg" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
return true
end
SendMetion(msg.chat_id,msg.sender_user_id, msg.id, '⇜ کاربر : '..msg.sender_user_id..' به علت ارسال بیش از حد پیام پاک شد', 10,string.len(msg.sender_user_id))
deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
end
if status == "muteuser" then
 if tonumber(msg.sender_user_id) == tonumber(TD_ID)  then
return true
end
if is_MuteUser(msg.chat_id,msg.sender_user_id) then
 else
SendMetion(msg.chat_id,msg.sender_user_id, msg.id, '⇜ کاربر : '..msg.sender_user_id..' به علت ارسال بیش از حد پیام در گروه محدود شد', 10,string.len(msg.sender_user_id))
mute(msg.chat_id,msg.sender_user_id or 021,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,msg.sender_user_id or 021)
end
end
end
if redis:get('Lock:Flood:'..msg.chat_id) then
if not is_Mod(msg) then
local post_count = 'user1:' .. msg.sender_user_id .. ':flooder'
local msgs = tonumber(redis:get(post_count) or 0)
if msgs > tonumber(NUM_MSG_MAX) then
if redis:get('user:'..msg.sender_user_id..':flooder') then
local status = redis:get('Flood:Status:'..msg.chat_id)
antifloodstats(msg,status)
return false
else
redis:setex('user:'..msg.sender_user_id..':flooder', 15, true)
end
end
redis:setex(post_count, tonumber(TIME_CHECK), msgs+1)
end
end
end
-------------MSG Matches ------------
local matches = msg.content.text
local matches1 = msg.content.text
if matches then
matches = matches:lower()
end
if matches1 then
matches1 = matches1:lower()
end
 if MsgType == 'text' and matches then
if matches:match('^[/#!]') then
matches= matches:gsub('^[/#!]','')
end
end
--------------MSG TYPE----------------
 if msg.content._== "messageText" then
MsgType = 'text'
end
 if msg.content._== "messageText" then
local function GetM(Company,MaTaDoR)
local function GetName(Companys,Company)
print("\027[" ..color.blue[1].. "m["..os.date("%H:%M:%S").."]\027[00m ["..MaTaDoR.title.."] "..Company.first_name.." >>>> "..msg.content.text.."")
end
GetUser(msg.sender_user_id,GetName)
end
GetChat(msg.chat_id,GetM)
end
if msg.content.caption then
function GetM(Company,MaTaDoR)
function GetName(Companys,Company)
print("["..os.date("%H:%M:%S").."] "..MaTaDoR.title.." "..Company.first_name.." >>>> "..msg.content.caption.."")
end
GetUser(msg.sender_user_id,GetName)
end
GetChat(msg.chat_id,GetM)
end
if msg.content._ == "messageChatAddMembers" then
function GetM(Company,MaTaDoR)
function GetName(Companys,Company)
for i=0,#msg.content.member_user_ids do
msg.add = msg.content.member_user_ids[i]
print("["..os.date("%H:%M:%S").."] "..MaTaDoR.title.." "..Company.first_name.." >>>> Added members "..msg.content.member_user_ids[i].." "..Company.first_name.."")
MsgType = 'AddUser'
end
end
GetUser(msg.sender_user_id,GetName)
end
GetChat(msg.chat_id,GetM)
end
if msg.content._ == "messageChatJoinByLink" then
function GetM(Company,MaTaDoR)
function GetName(Companys,Company)
print("["..os.date("%H:%M:%S").."] "..MaTaDoR.title.." >>>> Joined By link "..Company.first_name.."")
MsgType = 'JoinedByLink'
end
GetUser(msg.sender_user_id,GetName)
end
GetChat(msg.chat_id,GetM)
end
if msg.content._ == "messageDocument" then
function GetM(Company,MaTaDoR)
function GetName(Companys,Company)
print("["..os.date("%H:%M:%S").."] "..MaTaDoR.title.." "..Company.first_name.." >>>>[messageDocument][  "..Company.id.."]")
MsgType = 'Document'
end
GetUser(msg.sender_user_id,GetName)
end
GetChat(msg.chat_id,GetM)
end
if msg.content._ == "messageSticker" then
print("This is [ Sticker ]")
MsgType = 'Sticker'
end
if msg.content._ == "messageAudio" then
print("This is [ Audio ]")
MsgType = 'Audio'
end
if msg.content._ == "messageVoice" then
print("This is [ Voice ]")
MsgType = 'Voice'
end
if msg.content._ == "messageVideo" then
print("This is [ Video ]")
MsgType = 'Video'
end
if msg.content._ == "messageAnimation" then
print("This is [ Gif ]")
MsgType = 'Gif'
end
if msg.content._ == "messageLocation" then
print("This is [ Location ]")
MsgType = 'Location'
end
if msg.content._ == "messageForwardedFromUser" then
print("This is [ messageForwardedFromUser ]")
MsgType = 'messageForwardedFromUser'
end

if msg.content._ == "messageContact" then
print("This is [ Contact ]")
MsgType = 'Contact'
end
if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
print(serpent.block(data))
print("This is [ MarkDown ]")
MsgType = 'Markreed'
end
if msg.content.game then
print("This is [ Game ]")
MsgType = 'Game'
end
if msg.content._ == "messagePhoto" then
MsgType = 'Photo'
end
if msg.sender_user_id and is_GlobalyBan(msg.sender_user_id) and not TD_ID then
SendMetion(msg.chat_id,msg.sender_user_id, msg.id, '⇜ کاربر : '..msg.sender_user_id..' شما در لیست سیاه ربات قرار دارید', 10,string.len(msg.sender_user_id))
KickUser(msg.chat_id,msg.sender_user_id)
end

if MsgType == 'AddUser' then
function ByAddUser(MaTaDoR,Company)
if is_GlobalyBan(Company.id) then
print '                      >>>>Is  Globall Banned <<<<<       '
sendText(msg.chat_id, msg.id,'کاربر : `'..Company.id..'` در لیست سیاه قرار دارد','md')
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' در لیست سیاه قرار دارد', 10,string.len(Company.id))
end
GetUser(msg.content.member_user_ids[0],ByAddUser)
end
end
if msg.sender_user_id and is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
end
local welcome = (redis:get('Welcome:'..msg.chat_id) or 'disable') 
if welcome == 'enable' then
if MsgType == 'JoinedByLink' then
print '                       JoinedByLink                        '
if is_Banned(msg.chat_id,msg.sender_user_id) then
KickUser(msg.chat_id,msg.sender_user_id)
SendMetion(msg.chat_id,msg.sender_user_id, msg.id, '⇜ کاربر : '..msg.sender_user_id..' شما از این گروه محروم شده اید', 10,string.len(msg.sender_user_id))
else
function WelcomeByLink(MaTaDoR,Company)
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام\nخوش امدی'
end
local hash = "Rules:"..msg.chat_id
local matches = redis:get(hash) 
if matches then
rules=matches
else
rules= '⇜ `قوانین ثبت نشده است`'
end
local hash = "Link:"..msg.chat_id
local matches = redis:get(hash) 
if matches then
link=matches
else
link= '⇜ لینک گروه ثبت نشده است'
end
local txtt = txtt:gsub('{first}',ec_name(Company.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{last}',Company.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(Company.username) or '')
sendText(msg.chat_id, msg.id, txtt,'md')
 end
GetUser(msg.sender_user_id,WelcomeByLink)
end
end
if msg.add then
if is_Banned(msg.chat_id,msg.add) then
KickUser(msg.chat_id,msg.add)
SendMetion(msg.chat_id,msg.add, msg.id, '⇜ کاربر : '..msg.add..' شما از این گروه محروم شده اید', 10,string.len(msg.add))
else
function WelcomeByAddUser(MaTaDoR,Company)
print('New User : \nChatID : '..msg.chat_id..'\nUser ID : '..msg.add..'')
if redis:get('Text:Welcome:'..msg.chat_id) then
txtt = redis:get('Text:Welcome:'..msg.chat_id)
else
txtt = 'سلام\n خوش امدی'
end
local hash = "Rules:"..msg.chat_id
local matches = redis:get(hash) 
if matches then
rules=matches
else
rules= '⇜ قوانین ثبت نشده است'
end
local hash = "Link:"..msg.chat_id
local matches = redis:get(hash) 
if matches then
link=matches
else
link= '⇜ لینک گروه ثبت نشده است'
end
local txtt = txtt:gsub('{first}',ec_name(Company.first_name))
local txtt = txtt:gsub('{rules}',rules)
local txtt = txtt:gsub('{link}',link)
local txtt = txtt:gsub('{last}',Company.last_name or '')
local txtt = txtt:gsub('{username}','@'..check_markdown(Company.username) or '')
sendText(msg.chat_id, msg.id, txtt,'md')
end
GetUser(msg.add,WelcomeByAddUser)
end
end
end
viewMessages(msg.chat_id, {[0] = msg.id})
redis:incr('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
if msg.send_state._ == "messageIsSuccessfullySent" then
return false 
end   
----------Msg Checks-------------
local chat = msg.chat_id
if redis:get('CheckBot:'..msg.chat_id)  then
if not is_Owner(msg) then
if redis:get('Lock:Pin:'..chat) then
if msg.content._ == 'messagePinMessage' then
print '      Pinned By Not Owner       '
sendText(msg.chat_id, msg.id, 'Only Owners', 'md')
Unpin(msg.chat_id)
local PIN_ID = redis:get('Pin_id'..msg.chat_id)
if Pin_id then
Pin(msg.chat_id, tonumber(PIN_ID), 0)
end
end
end
end
if not is_Mod(msg) and not is_Vip(msg)  then
local chat = msg.chat_id
local user = msg.sender_user_id
----------Lock Link-------------
if redis:get('Lock:Link'..chat) then
 if matches then
local link = (matches:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or matches:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or matches:match("[Tt].[Mm][Ee]/") or matches:match('(.*)[.][mM][Ee]') or matches:match('[Ww][Ww][Ww].(.*)') or matches:match('(.*).[Ii][Rr]') or matches:match('[Hh][Tt][Tt][Pp][Ss]://(.*)') or matches:match('[Ww][Ww][Ww].(.*)') or msg.content.text:match('http://(.*)'))
if link  then
if msg.content.entities and msg.content.entities[0] and msg.content.entities[0].type._ == "textEntityTypeUrl" then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Link] ")
end
end
end

if msg.content.caption then
local cap = msg.content.caption
local link = (cap:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or cap:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or cap:match("[Tt].[Mm][Ee]/") or cap:match('(.*)[.][mM][Ee]') or cap:match('(.*).[Ii][Rr]') or cap:match('[Ww][Ww][Ww].(.*)') or cap:match('[Hh][Tt][Tt][Pp][Ss]://') or msg.content.caption:match('http://(.*)'))
if link then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [Link] ")

end
end
end 
---------------------------
if redis:get('Lock:Tag:'..chat) then
if matches then
local tag = matches:match("@(.*)") or matches:match("@")
if tag then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Tag] ")

end
end
if msg.content.caption then
local matches = msg.content.caption
local tag = matches:match("@(.*)")
if itag then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [Tag] ")

end
end
end
---------------------------
if redis:get('Lock:HashTag:'..chat) then
if msg.content.text then
if msg.content.text:match("#(.*)") or msg.content.text:match("#(.*)") or msg.content.text:match("#") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [HashTag] ")
end
end
if msg.content.caption then
if msg.content.caption:match("#(.*)")  or msg.content.caption:match("(.*)#") or msg.content.caption:match("#") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] [HashTag] ")

end
end
end
---------------------------
if redis:get('Lock:Video_note:'..chat) then
if msg.content._ == 'messageVideoNote' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [VideoNote] ")
end
end
---------------------------
if redis:get('Lock:Arabic:'..chat) then
 if matches and matches:match("[\216-\219][\128-\191]") then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Persian] ")
end 
if msg.content.caption then
local matches = msg.content.caption
local is_persian = matches:match("[\216-\219][\128-\191]")
if is_persian then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Persian] ")
end
end
end
--------------------------
if redis:get('Lock:English:'..chat) then
if matches and (matches:match("[A-Z]") or matches:match("[a-z]")) then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [English] ")
end 
if msg.content.caption then
local matches = msg.content.caption
local is_english = (matches:match("[A-Z]") or matches:match("[a-z]"))
if is_english then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [ENGLISH] ")
end
end
end
if redis:get('Spam:Lock:'..chat) then
 if MsgType == 'text' then
 local _nl, ctrl_chars = string.gsub(msg.content.text, '%c', '')
 local _nl, real_digits = string.gsub(msg.content.text, '%d', '')
local hash = 'NUM_CH_MAX:'..msg.chat_id
if not redis:get(hash) then
sens = 40
else
sens = tonumber(redis:get(hash))
end
local max_real_digits = tonumber(sens) * 50
local max_len = tonumber(sens) * 51
if string.len(msg.content.text) >  sens or ctrl_chars > sens or real_digits >  sens then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Spam] ")
end
end
end
----------Filter------------
if matches then
 if is_filter(msg,matches) then
 deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Filter] ")

 end 
end
-----------------------------------------------
if redis:get('Lock:Bot:'..chat) then
if msg.add then
function ByAddUser(MaTaDoR,Company)
if Company.type._ == "userTypeBot" then
print '               Bot added              '  
KickUser(msg.chat_id,Company.id)
end
end
GetUser(msg.add,ByAddUser)
end
end
-----------------------------------------------
if redis:get('Lock:Markdown:'..chat) then
if msg.content.entities and msg.content.entities[0] and (msg.content.entities[0].type._ == "textEntityTypeBold" or msg.content.entities[0].type._ == "textEntityTypeCode" or msg.content.entities[0].type._ == "textEntityTypeitalic") then 
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Markdown] ")
end
end
----------------------------------------------
if redis:get('Lock:Inline:'..chat) then
 if not msg.reply_markup and msg.via_bot_user_id ~= 0 then
 deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Inline] ")
end
end
----------------------------------------------
if redis:get('Lock:TGservise:'..chat) then
if msg.content._ == "messageChatJoinByLink" or msg.content._ == "messageChatAddMembers" or msg.content._ == "messageChatDeleteMember" then
 deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
------------------------------------------------
if redis:get('Lock:Forward:'..chat) then
if msg.forward_info then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
--------------------------------
if redis:get('Lock:Sticker:'..chat) then
if  MsgType == 'Sticker' then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
----------Lock Edit-------------
if redis:get('Lock:Edit'..chat) then
if msg.edit_date > 0 then
deleteMessages(msg.chat_id, {[0] = msg.id})
end
end
-------------------------------Mutes--------------------------
if redis:get('Mute:Text:'..chat) then
if MsgType == 'text' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Text] ")
end
end
--------------------------------
if redis:get('automuteall'..msg.chat_id) and (redis:get("automutestart"..msg.chat_id) or redis:get("automuteend"..msg.chat_id)) then
local time = os.date("%H%M")
local start = redis:get("automutestart"..msg.chat_id)
local endtime = redis:get("automuteend"..msg.chat_id)
if tonumber(endtime) < tonumber(start) then
if tonumber(time) <= 2359 and tonumber(time) >= tonumber(start) then
if not redis:get("MuteAll:"..msg.chat_id) then
redis:set("MuteAll:"..msg.chat_id,true)
end
elseif tonumber(time) >= 0000 and tonumber(time) < tonumber(endtime) then
if not redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'⇜ گروه قفل میباشد لطفا پیامی ارسال نکنید !' , 'md')
redis:set("MuteAll:"..msg.chat_id,true)
end
else
if redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'⇜ قفل خودکار غیرفعال شد !' , 'md')
local mutes =  redis:smembers('Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
redis:srem('MuteList:'..msg.chat_id,v)
mute(msg.chat_id,v,'Restricted',   {1, 1, 1, 1, 1,1})
redis:del("MuteAll:"..msg.chat_id)
end
end
end
elseif tonumber(endtime) > tonumber(start) then
if tonumber(time) >= tonumber(start) and tonumber(time) < tonumber(endtime) then
if not redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'⇜ گروه قفل میباشد لطفا پیامی ارسال نکنید !' , 'md')
redis:set("MuteAll:"..msg.chat_id,true)
end
else
if redis:get("MuteAll:"..msg.chat_id) then
sendText(msg.chat_id, msg.id,'⇜ قفل خودکار غیرفعال شد !' , 'md')
redis:del("MuteAll:"..msg.chat_id)
end
end
end
end
-----------------------------------------
if redis:get('Mute:Photo:'..chat) then
 if MsgType == 'Photo' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Photo] ")
end
end 
-------------------------------
if redis:get('Mute:Caption:'..chat) then
if msg.content.caption then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Caption] ")
end
end 
-------------------------------
if redis:get('Mute:Reply:'..chat) then
if tonumber(msg.reply_to_message_id) > 0 then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Reply] ")
end
end 
-------------------------------
if redis:get('Mute:Document:'..chat) then
if MsgType == 'Document' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Docment] ")
end
end
---------------------------------
if redis:get('Mute:Location:'..chat) then
if MsgType == 'Location' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print("Deleted [Lock] [Location] ")
end
end
-------------------------------
if redis:get('Mute:Voice:'..chat) then
if MsgType == 'Voice' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print(" Deleted [Lock] [Voice] ")
end
end
-------------------------------
if redis:get('Mute:Contact:'..chat) then
if MsgType == 'Contact' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print(" Deleted [Lock] [Contact] ")
end
end
-------------------------------
if redis:get('Mute:Game:'..chat) then
if MsgType == 'Game' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print(" Deleted [Lock] [Game] ")
end
end
--------------------------------
if redis:get('Mute:Video:'..chat) then
if MsgType == 'Video' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print(" Deleted [Lock] [Video] ")
end
end
--------------------------------
if redis:get('Mute:Music:'..chat) then
if MsgType == 'Audio' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print(" Deleted [Lock] [Music] ")
end
end
-----------Mtes Gif------------
if redis:get('Mute:Gif:'..chat) then
if MsgType == 'Gif' then
deleteMessages(msg.chat_id, {[0] = msg.id})
print(" Deleted [Lock] [Gif] ")
end
end
end
end
------------Chat Type------------
function is_channel(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^-100') then 
if msg.is_post then
return true
else
return false
end
end
end
function is_group(msg)
chat_id= tostring(msg.chat_id)
if chat_id:match('^-100') then 
return false
elseif chat_id_:match('^-') then
return true
else
return false
end
end
function is_private(msg)
chat_id = tostring(msg.chat_id)
if chat_id:match('^(%d+)') then
print'           ty                                   '
return false
else
return true
end
end
function gp_type(chat_id)
  local gp_type = "pv"
  local id = tostring(chat_id)
    if id:match("^-100") then
      gp_type = "channel"
    elseif id:match("-") then
      gp_type = "chat"
  end
  return gp_type
end
local function run_bash(str)
local cmd = io.popen(str)
local result = cmd:read('*all')
return result
end
if is_Fullsudo(msg) then
if matches and (matches:match('^setsudo (%d+)') or matches:match('^افزودن سودو (%d+)')) then
local sudo = matches:match('^setsudo (%d+)') or matches:match('^افزودن سودو (%d+)')
redis:sadd('SUDO-ID',sudo)
SendMetion(msg.chat_id,sudo, msg.id, '⇜ کاربر : '..sudo..' به لیست سودو های ربات اضافه شد', 10,string.len(sudo))
end
if matches and (matches:match('^remsudo (%d+)') or matches:match('^حذف سودو (%d+)')) then
local sudo = matches:match('^remsudo (%d+)') or matches:match('^حذف سودو (%d+)')
redis:srem('SUDO-ID',sudo)
SendMetion(msg.chat_id,sudo, msg.id, '⇜ کاربر : '..sudo..' از لیست صاحبان ربات حذف شد', 10,string.len(sudo))
end
if matches == 'sudolist' or matches == 'لیست سودو ها' then
local hash =  "SUDO-ID"
local list = redis:smembers(hash)
local t = '*لیست سودو ها :*\n'
for k,v in pairs(list) do 
local user_info = redis:hgetall('user:'..v)
if user_info then
t = t..k.." - ["..v.."]\n"
else
t = t..k.." - "..v.."\n"
end
end
if #list == 0 then
t = '⇜ لیست سودو های ربات خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
end
----------------- Monshi -------------
if gp_type(msg.chat_id) == "pv" then
if matches == 'نرخ' then
local text = [[
*💵 نرخ فروش ربات* 

*✳️برای تمام گروه ها‌*
 
*➰1 ماهه 10 هزا تومان 
➰2 ماهه  15 هزار تومان
➰3 ماهه  20 هزار تومان
➰4 ماهه  25 هزار تومان*

_🔰 نکته مهم :_

`🎖توجه داشته باشید ربات به مدت  ۴۸ ساعت رایگان برای تست در گروه نصب می‌شود و بعد تست و رضایت کامل اعمالات صورت می‌گیرد`

*برای خرید به گروه پشتیبانی مراجعه و اعلام کنید:*
🆔 : 
]]..check_markdown(UserSudo)..[[

]]..check_markdown(PvUserSudo)..[[

]]
sendText(msg.chat_id, msg.id, text,'md')
elseif matches:match('(.*)') and not is_sudo(msg) then
local chkpm = redis:get(msg.sender_user_id..'MonShi1')
local text = '_سلام\nمن رباتی هستم که میتوانم گروه شمارو ضد لینک و ضد تبلیغ کنم\nخب اگه میخوای منو داشته باشی و به من نیاز داری که تو گروهت مدیریت کنم وارد گروه پشتیبانی شو 😝_\n\n*لینک گروه پشتیبانی :*\n'..check_markdown(LinkSuppoRt)..'\n\n*برای کسب اطلاعات بیشتر میتوانید در کانال ما عضو شوید :*\n'..check_markdown(Channel)..'\n\n_برای دریافت قیمت ربات دستور_ *"نرخ"* _را ارسال کنید._'
if not chkpm then
redis:set(msg.sender_user_id..'MonShi1', true)
sendText(msg.chat_id, msg.id, text,'md')
else
end
end
end
----------------- End Monshi -------------
if is_supergroup(msg) then
if is_sudo(msg) then
if (matches == 'bc' or matches == 'ارسال به همه') and tonumber(msg.reply_to_message_id) > 0 then
function Test(MaTaDoR,Company)
local text = Company.content.text
local list = redis:smembers('CompanyAll')
for k,v in pairs(list) do
sendText(v, 0, text, 'md')
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Test)
end
if (matches == 'fwd' or matches == 'فوروارد به همه') and tonumber(msg.reply_to_message_id) > 0 then
function Test(MaTaDoR,Company)
local list = redis:smembers('CompanyAll')
for k,v in pairs(list) do
ForMsg(v, msg.chat_id, {[0] = Company.id}, 1)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Test)
end
if matches == 'add' or matches == 'نصب' then
local function GetName(MaTaDoR, Company)
if not redis:get("ExpireData:"..msg.chat_id) then
redis:setex("ExpireData:"..msg.chat_id,day,true)
end 
 redis:sadd("group:",msg.chat_id)
if redis:get('CheckBot:'..msg.chat_id) then
local text = '⇜ گروه `'..Company.title..'` از قبل در لیست گروه های مدیریتی ربات وجود دارد'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '⇜ `گروه ` *'..Company.title..'* ` به لیست گروه های مدیریتی اضافه شد`'
local Hash = 'StatsGpByName'..msg.chat_id
local ChatTitle = Company.title
redis:set(Hash,ChatTitle)
print('⇜ New Group\nChat name : '..Company.title..'\nChat ID : '..msg.chat_id..'\nBy : '..msg.sender_user_id)
local textlogs =[[
⇜ گروه جدیدی به لیست مدیریت اضافه شد 

⇜ اطلاعات گروه :

⇜ نام گروه ]]..Company.title..[[

⇜ آیدی گروه : ]]..msg.chat_id..[[

⇜ توسط : ]]..msg.sender_user_id..[[

]]
redis:set('CheckBot:'..msg.chat_id,true) 
if not redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
 sendText(msg.chat_id, msg.id,text,'md')

 sendText(Sudoid, 0,textlogs,'html')
end
end
GetChat(msg.chat_id,GetName)
end
if matches == 'gid' or matches == 'ایدی گروه' then 
sendText(msg.chat_id,msg.id,''..msg.chat_id..'','md')
end
			
if matches == 'reload' or matches == 'بروز' then
dofile('./Cli.lua')
io.popen("rm -rf ~/.telegram-bot/main/files/animations/*")
io.popen("rm -rf ~/.telegram-bot/main/files/documents/*")
io.popen("rm -rf ~/.telegram-bot/main/files/music/*")
io.popen("rm -rf ~/.telegram-bot/main/files/photos/*")
io.popen("rm -rf ~/.telegram-bot/main/files/temp/*")
io.popen("rm -rf ~/.telegram-bot/main/files/video_notes/*")
io.popen("rm -rf ~/.telegram-bot/main/files/videos/*")
io.popen("rm -rf ~/.telegram-bot/main/files/voice/*")
sendText(msg.chat_id,msg.id,'⇜ سیستم ربات بروز شد','md')
end 
if matches == 'rem' or matches == 'لغو نصب' then
local function GetName(MaTaDoR, Company)
redis:del("ExpireData:"..msg.chat_id)
redis:srem("group:",msg.chat_id)
redis:del("OwnerList:"..msg.chat_id)
redis:del("ModList:"..msg.chat_id)
redis:del('StatsGpByName'..msg.chat_id)
redis:del('CheckExpire:'..msg.chat_id)
 if not redis:get('CheckBot:'..msg.chat_id) then
local text = '⇜ گروه  `'..Company.title..'` در لیست گروه های مدیریتی قرار ندارد'
 sendText(msg.chat_id, msg.id,text,'md')
else
local text = '⇜ `گروه ` *'..Company.title..'* ` از لیست گروه های مدیریتی حذف شد`'
local Hash = 'StatsGpByName'..msg.chat_id
redis:del(Hash)
 sendText(msg.chat_id, msg.id,text,'md')
 redis:del('CheckBot:'..msg.chat_id) 
end
end
GetChat(msg.chat_id,GetName)
end
if matches == 'full' or matches == 'نامحدود' then
redis:set("ExpireData:"..msg.chat_id,true)
sendText(msg.chat_id ,msg.id,"⇜ گروه به صورت نامحدود شارژ شد",'md')
if redis:get('CheckExpire:'..msg.chat_id) then
redis:set('CheckExpire:'..msg.chat_id,true)
end
end
-----------Leave----------------------------------
if matches1 and (matches1:match('^leave (-100)(%d+)$') or matches1:match('^خروج (-100)(%d+)$')) then
local chat_id = matches1:match('^leave (.*)$') or matches1:match('^خروج (.*)$') 
redis:del("ExpireData:"..chat_id)
redis:srem("group:",chat_id)
redis:del("OwnerList:"..chat_id)
redis:del("ModList:"..chat_id)
redis:del('StatsGpByName'..chat_id)
redis:del('CheckExpire:'..chat_id)
sendText(msg.chat_id,msg.id,'⇜ ربات از گروه  '..chat_id..' خارج شد','md')
sendText(chat_id,0,'','md')
Left(chat_id,TD_ID, "Left")
end 
if matches == 'chats' or matches == 'لیست گروه ها' then
local list = redis:smembers('group:')
local t = '💢 لیست گروه ها ربات :\n'
for k,v in pairs(list) do
local expire = redis:ttl("ExpireData:"..v)
if expire == -1 then
EXPIRE = "نامحدود"
else
local d = math.floor(expire / day ) + 1
EXPIRE = d.." روز"
end
local GroupsName = redis:get('StatsGpByName'..v)
t = t..k.."-\n⇜ آیدی گروه : ["..v.."]\n⇜ اسم گروه : ["..GroupsName.."]\n⇜ تاریخ انقضا گروه : ["..EXPIRE.."]\n❦❧❦❧❦❧❦❧❦❧\n" 
end
local file = io.open("./Download/Gplist.txt", "w")
file:write(t)
file:close()
if #list == 0 then
t = 'لیست گروهها خالی میباشد !'
end
sendDocument(msg.chat_id,msg.id,0,1,nil,'./Download/Gplist.txt')
end
if matches == 'backup' or matches == 'بک اپ' then
sendDocument(Sudoid, 0, 0, 1, nil, './Cli.lua', dl_cb, nil)
sendDocument(Sudoid, 0, 0, 1, nil, './Config.lua', dl_cb, nil)
sendDocument(Sudoid, 0, 0, 1, nil, './Api.lua', dl_cb, nil)
sendText(msg.chat_id, msg.id,'⇜ آخرین نسخه سورس به پیوی سازنده ربات ارسال شد.','md')
end
if matches and (matches:match('^charge (%d+)$') or matches:match('^شارژ (%d+)$')) then
local function GetName(MaTaDoR, Company)
local time = tonumber(matches:match('^charge (%d+)$') or matches:match('^شارژ (%d+)$')) * day
 redis:setex("ExpireData:"..msg.chat_id,time,true)
local ti = math.floor(time / day )
local text = '⇜ `گروه ` *'..Company.title..'* ` شارژ شد ` به مدت  *'..ti..'* روز'
sendText(msg.chat_id, msg.id,text,'md')
if redis:get('CheckExpire:'..msg.chat_id) then
 redis:set('CheckExpire:'..msg.chat_id,true)
end
end
GetChat(msg.chat_id,GetName)
end
if matches == "expire" or matches == "اعتبار" then
local ex = redis:ttl("ExpireData:"..msg.chat_id)
if ex == -1 then
sendText(msg.chat_id, msg.id,  "⇜ نامحدود", 'md' )
else
local d = math.floor(ex / day ) + 1
sendText(msg.chat_id, msg.id,d.." روز",  'md' )
end
end
if matches == 'leave' or matches == 'خروج' then
sendText(msg.chat_id, msg.id,  "⇜ ربات از گروه خارج میشود", 'md' )
Left(msg.chat_id, TD_ID, 'Left')
end
if matches == 'stats' or matches == 'آمار' then
local allmsgs = redis:get('allmsgs')
local supergroup = redis:scard('ChatSuper:Bot')
local Groups = redis:scard('Chat:Normal')
local users = redis:scard('ChatPrivite')
local user = io.popen("whoami"):read('*a')
 local uptime = io.popen("uptime -p"):read("*a")
local totalredis =  io.popen("du -h /var/lib/redis/dump.rdb"):read("*a")
local text =[[
⇜ تمام پیام های چک شده  : ]]..allmsgs..[[

⇜ سوپر گروه ها :]]..supergroup..[[

⇜ گروه ها : ]]..Groups..[[

⇜ کاربران   : ]]..users..[[

⇜ یوزر : ]]..user..[[

⇜ آپتایم : ]]..uptime..[[

⇜ مقدار مصرف شده ردیس : ]]..totalredis..[[

]]
sendText(msg.chat_id, msg.id,text,  'md' )
end
if matches == 'reset' or matches == 'ریست' then
 redis:del('allmsgs')
redis:del('ChatSuper:Bot')
 redis:del('Chat:Normal')
 redis:del('ChatPrivite')
sendText(msg.chat_id, msg.id,'⇜ آمار ربات از نو شروع شد',  'md' )
end
if matches == 'ownerlist' or matches == 'لیست مالکان' then
local list = redis:smembers('OwnerList:'..msg.chat_id)
local t = '⇜ لیست مالکان :\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n⇜ شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nاطلاعات 377450049"
if #list == 0 then
t = '⇜ لیست مالکان خالی میباشد'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if matches and (matches:match('^setrank (.*)$') or matches:match('^تنظیم مقام (.*)$')) then
local rank = matches:match('^setrank (.*)$') or matches:match('^تنظیم مقام (.*)$')
local function SetRank_Rep(MaTaDoR, Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:set('rank'..Company.sender_user_id,rank)
local user = Company.sender_user_id
SendMetion(msg.chat_id,user, msg.id, '⇜ مقام کاربر '..user..' به '..rank..' تغییر کرد', 13,string.len(user))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetRank_Rep)
end
end
----------------------SetOwner--------------------------------
if matches == 'setowner' or matches == 'مالک' then
local function SetOwner_Rep(MaTaDoR, Company)
local user = Company.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' در لیست صاحبان گروه قرار دارد..!', 10,string.len(Company.sender_user_id))
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' به لیست صاحبان گروه اضافه شد ..', 10,string.len(Company.sender_user_id))
redis:sadd('OwnerList:'..msg.chat_id,user or 00000000)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetOwner_Rep)
end
end
if matches and (matches:match('^setowner (%d+)') or matches:match('^مالک (%d+)')) then
local user = matches:match('setowner (%d+)') or matches:match('^مالک (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' از قبل در لیست صاحبان گروه قرار داشت', 10,string.len(user))
else
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' به لیست صاحبان گروه اضافه شد', 10,string.len(user))
redis:sadd('OwnerList:'..msg.chat_id,user)
end
end
if matches and (matches:match('^setowner @(.*)') or matches:match('^مالک @(.*)')) then
local username = matches:match('^setowner @(.*)') or matches:match('^مالک @(.*)')
function SetOwnerByUsername(MaTaDoR,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('OwnerList:'..msg.chat_id,Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..'از قبل در لیست صاحبان گروه قرار داشت ', 10,string.len(Company.id))
else
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' به لیست صاحبان گروه اضافه شد', 10,string.len(Company.id))
redis:sadd('OwnerList:'..msg.chat_id,Company.id)
end
else 
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,SetOwnerByUsername)
end
if matches == 'remowner' or matches == 'حذف مالک' then
local function RemOwner_Rep(MaTaDoR, Company)
local user = Company.sender_user_id
if redis:sismember('OwnerList:'..msg.chat_id, Company.sender_user_id) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' از لیست صاحبان گروه حذف شد ', 9,string.len(Company.sender_user_id))
redis:srem('OwnerList:'..msg.chat_id,Company.sender_user_id)
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' در لیست صاحبان گروه وجود ندارد', 9,string.len(Company.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemOwner_Rep)
end
end
if matches and (matches:match('^remowner (%d+)') or matches:match('^حذف مالک (%d+)')) then
local user = matches:match('remowner (%d+)') or matches:match('^حذف مالک (%d+)')
if redis:sismember('OwnerList:'..msg.chat_id,user) then
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' از لیست صاحبان گروه حذف شد ', 10,string.len(user))
redis:srem('OwnerList:'..msg.chat_id,user)
else
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' در لیست صاحبان گروه وجود ندارد',10,string.len(user))
end
end
if matches and (matches:match('^remowner @(.*)') or matches:match('^حذف مالک @(.*)')) then
local username = matches:match('^remowner @(.*)') or matches:match('^حذف مالک @(.*)')
function RemOwnerByUsername(MaTaDoR,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('OwnerList:'..msg.chat_id, Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' از لیست صاحبان گروه پاک شد', 10,string.len(Company.id))
redis:srem('OwnerList:'..msg.chat_id,Company.id)
else
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' در لیست صاحبان گروه وجود ندارد', 10,string.len(Company.id))
end
else  
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,RemOwnerByUsername)
end
if matches == 'clean ownerlist' or matches == 'پاکسازی لیست مالکان' then
redis:del('OwnerList:'..msg.chat_id)
sendText(msg.chat_id, msg.id,'⇜ لیست صاحبان گروه پاکسازی شد', 'md')
end
---------Start---------------Globaly Banned-------------------
if matches == 'banall' or matches == 'مسدود همگانی' then
function GbanByReply(MaTaDoR,Company)
if redis:sismember('GlobalyBanned:',Company.sender_user_id) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' قبلا در لیست وجود دارد', 10,string.len(Company.sender_user_id))
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' به لیست سیاه اضافه شد', 10,string.len(Company.sender_user_id))
redis:sadd('GlobalyBanned:',Company.sender_user_id)
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GbanByReply)
end
end
if matches and (matches:match('^banall (%d+)') or matches:match('^مسدود همگانی (%d+)')) then
local user = matches:match('^banall (%d+)') or matches:match('^مسدود همگانی (%d+)')
if redis:sismember('GlobalyBanned:',user) then
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' قبلا در لیست وجود دارد', 10,string.len(user))
else
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' به لیست سیاه اضافه شد', 10,string.len(user))
redis:sadd('GlobalyBanned:',user)
end
end
if matches and (matches:match('^banall @(.*)') or matches:match('^مسدود همگانی @(.*)')) then
local username = matches:match('^banall @(.*)') or matches:match('^مسدود همگانی @(.*)')
function BanallByUsername(MaTaDoR,Company)
if Company.id then
print(''..Company.id..'')
if redis:sismember('GlobalyBanned:', Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' قبلا در لیست وجود دارد', 10,string.len(Company.id))
else
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' به لیست سیاه اضافه شد', 10,string.len(Company.id))
redis:sadd('GlobalyBanned:',Company.id)
end
else 
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,BanallByUsername)
end
if matches == 'gbans' or matches == 'لیست مسدود همگانی' then
local list = redis:smembers('GlobalyBanned:')
local t = 'Globaly Ban:\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n⇜ شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nاطلاعات 377450049"
if #list == 0 then
t = '⇜ لیست مسدود همگانی خالی میباشد'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if matches == 'clean gbans' or matches == 'پاکسازی لیست مسدود همگانی' then
redis:del('GlobalyBanned:')
sendText(msg.chat_id, msg.id,'⇜ لیست سیاه پاکسازی شد', 'md')
end
---------------------Unbanall--------------------------------------
if matches and (matches:match('^unbanall (%d+)') or matches:match('^حذف مسدود همگانی (%d+)')) then
local user = matches:match('unbanall (%d+)') or matches:match('حذف مسدود همگانی (%d+)')
if tonumber(user) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if redis:sismember('GlobalyBanned:',user) then
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' از لیست سیاه حذف  شد', 10,string.len(user))
redis:srem('GlobalyBanned:',user)
else
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' در لیست سیاه وجود ندارد', 10,string.len(user))
end
end
if matches and (matches:match('^unbanall @(.*)') or matches:match('^حذف مسدود همگانی @(.*)')) then
local username = matches:match('^unbanall @(.*)') or matches:match('^حذف مسدود همگانی @(.*)')
function UnbanallByUsername(MaTaDoR,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if Company.id then
print(''..Company.id..'')
if redis:sismember('GlobalyBanned:',Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' از لیست سیاه حذف  شد', 10,string.len(Company.id))
redis:srem('GlobalyBanned:',Company.id)
else
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' در لیست سیاه وجود ندارد', 10,string.len(Company.id))
end
else 
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,UnbanallByUsername)
end
if matches == 'unbanall' or matches == 'حذف مسدود همگانی' then
function UnGbanByReply(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if redis:sismember('GlobalyBanned:',Company.sender_user_id) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' از لیست سیاه حذف  شد', 10,string.len(Company.sender_user_id))
redis:srem('GlobalyBanned:',Company.sender_user_id)
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' در لیست سیاه وجود ندارد', 10,string.len(Company.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnGbanByReply)
end
end
if matches == 'clean members' or matches == 'پاکسازی کاربر' then 
function CleanMembers(MaTaDoR, Company) 
for k, v in pairs(Company.members) do 
if tonumber(v.user_id) == tonumber(TD_ID)  then
return true
end
KickUser(msg.chat_id,v.user_id)
end
end
getChannelMembers(msg.chat_id,"Recent",0, 2000000,CleanMembers)
sendText(msg.chat_id, msg.id,'⇜ مقداری از کاربران گروه اخراج شده اند', 'md') 
end 
if matches == 'addkick' or matches == 'دعوت مسدود'  then
local function Clean(MaTaDoR,Company)
for k,v in pairs(Company.members) do
addChatMembers(msg.chat_id,{[0] = v.user_id})
end
end
getChannelMembers(msg.chat_id,"Banned", 0, 200,Clean)
sendText(msg.chat_id, msg.id, 'کاربران لیست سیاه به گروه اضافه شده اند', 'md')
end
-------------------------------
end
if is_Owner(msg) then
if matches == 'lock pin' or matches == 'قفل سنجاق' then
if redis:get('Lock:Pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ قفل سنجاق از قبل فعال بود' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ قفل سنجاق فعال شد' , 'md')
redis:set('Lock:Pin:'..msg.chat_id,true)
end
end
if matches == 'unlock pin' or matches == 'بازکردن سنجاق' then
if redis:get('Lock:pin:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ قفل سنجاق غیرفعال شد' , 'md')
redis:del('Lock:Pin:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ قفل سنجاق از قبل غیرفعال بود' , 'md')
end
end
if matches == 'config' or matches == 'پیکربندی' then
if not limit or limit > 200 then
limit = 200
end  
local function GetMod(extra,result,success)
local c = result.members
for i=0 , #c do
redis:sadd('ModList:'..msg.chat_id,c[i].user_id)
end
sendText(msg.chat_id,msg.id,"⇜ تمام مدیران گروه به رسمیت شناخته شده اند", "md")
end
getChannelMembers(msg.chat_id,'Administrators',0,limit,GetMod)
end
if matches == 'modlist' or matches == 'لیست مدیران' then
local list = redis:smembers('ModList:'..msg.chat_id)
local t = '⇜ لیست مدیران :\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n⇜ شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nاطلاعات 377450049"
if #list == 0 then
t = 'لیست مدیران خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if matches and (matches:match('^unmuteuser (%d+)$') or matches:match('^حذف سکوت (%d+)$')) then
local mutes =  matches:match('^unmuteuser (%d+)$') or matches:match('^حذف سکوت (%d+)$')
if tonumber(mutes) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,mutes)
mute(msg.chat_id, mutes,'Restricted',   {1, 1, 1, 1, 1,1})
SendMetion(msg.chat_id,mutes, msg.id, '⇜ کاربر : '..mutes..' از حالت سکوت خارج شد', 10,string.len(mutes))
end
if matches == 'clean msgs' or matches == 'پاکسازی پیام ها'  then
local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Search' 
end
end
for i = 1,2 do
getChannelMembers(msg.chat_id,"Search", 0, 20000,pro)
end
end
if matches == 'clean msgs' or matches == 'پاکسازی پیام ها' then
function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
print 'Clean By Del msg id ' 
end
end
for i = 1,5 do
getChatHistory(msg.chat_id,msg.id, 0,  500000000,cb)
end
end
if matches == 'clean msgs' or matches == 'پاکسازی پیام ها' then
local function pro(arg,data)
for k,v in pairs(data.members) do
deleteMessagesFromUser(msg.chat_id, v.user_id) 
end
end
for i = 1, 1 do
getChannelMembers(msg.chat_id,  "Recent",0,200000 ,pro)
end
sendText(msg.chat_id, msg.id,'⇜ (در حال پاکسازی همه پیام ها) 🗑' ,'md')
end
if matches == "clean deleted" or matches == 'پاکسازی دیلت اکانتی' then
function list(MaTaDoR,Company)
for k,v in pairs(Company.members) do
local function Checkdeleted(MaTaDoR,Company)
if Company.type._ == "userTypeDeleted" then
KickUser(msg.chat_id,Company.id)
end
end
GetUser(v.user_id,Checkdeleted)
print(v.user_id)
end
sendText(msg.chat_id, msg.id,'⇜ تمام کاربران دیلیت اکانتی از گروه حذف شداند' ,'md')
end
tdbot_function ({_= "getChannelMembers",channel_id = getChatId(msg.chat_id).id,offset = 0,limit= 1000}, list, nil)
end
if matches == 'clean msgs' or matches == 'پاکسازی پیام ها' then
 local function pro(arg,data)
for k,v in pairs(data.members) do
 deleteMessagesFromUser(msg.chat_id, v.user_id) 
print 'Clean By Del From User ' 
end
end
for i = 1,5 do
getChannelMembers(msg.chat_id,  "Banned",0,2000000000 ,pro)
end
end
if matches == 'promote' or matches == 'مدیر' then
function PromoteByReply(MaTaDoR,Company)
redis:sadd('ModList:'..msg.chat_id,Company.sender_user_id)
local user = Company.sender_user_id
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' ترفیع یافت', 10,string.len(user))
end
if tonumber(msg.reply_to_message_id_) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id), PromoteByReply)  
end
end
if matches == 'demote' or matches == 'حذف مدیر' then
function DemoteByReply(MaTaDoR,Company)
redis:srem('ModList:'..msg.chat_id,Company.sender_user_id)
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' عزل مقام شد', 10,string.len(Company.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DemoteByReply)  
end
end
if matches and (matches:match('^demote @(.*)') or matches:match('^حذف مدیر @(.*)')) then
local username = matches:match('^demote @(.*)') or matches:match('^حذف مدیر @(.*)')
function DemoteByUsername(MaTaDoR,Company)
if Company.id then
print(''..Company.id..'')
redis:srem('ModList:'..msg.chat_id,Company.id)
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' عزل مقام شد', 10,string.len(Company.id))
else 
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,DemoteByUsername)
end
--------------------

if matches and (matches:match('^promote @(.*)') or matches:match('^مدیر @(.*)')) then
local username = matches:match('^promote @(.*)') or matches:match('^مدیر @(.*)')
function PromoteByUsername(MaTaDoR,Company)
if Company.id then
print(''..Company.id..'')
redis:sadd('ModList:'..msg.chat_id,Company.id)
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' ترفیع یافت', 10,string.len(Company.id))
else 
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,PromoteByUsername)
end
----------------------
if matches1 and (matches1:match('^[Ss]etdescription (.*)') or matches1:match('^تنظیم درباره (.*)')) then
local description = matches1:match('^[Ss]etdescription (.*)') or matches1:match('^تنظیم درباره (.*)')
changeDes(msg.chat_id,description)
local text = [[⇜ درباره گروه به  ]]..description..[[ تغییر یافت ]]
sendText(msg.chat_id, msg.id, text, 'md')
end
if matches1 and (matches1:match('^[Ss]etname (.*)') or matches1:match('^تنظیم نام (.*)')) then
local Title = matches1:match('^[Ss]etname (.*)') or matches1:match('^تنظیم نام (.*)')
local function GetName(MaTaDoR, Company)
local Hash = 'StatsGpByName'..msg.chat_id
local ChatTitle = Company.title
redis:set(Hash,ChatTitle)
changeChatTitle(msg.chat_id,Title)
local text = [[⇜ نام گروه تغییر یافت به :]]..Title
sendText(msg.chat_id, msg.id, text, 'md')
end
GetChat(msg.chat_id,GetName)
end
if matches and (matches:match('^promote (%d+)') or matches:match('^مدیر (%d+)')) then
local user = matches:match('promote (%d+)') or matches:match('مدیر (%d+)')
redis:sadd('ModList:'..msg.chat_id,user)
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' ترفیع یافت', 10,string.len(user))
end
if (matches == 'pin' or matches == 'سنجاق') and  tonumber(msg.reply_to_message_id) > 0 then 
sendText(msg.chat_id,msg.reply_to_message_id, '⇜ این پیام سنجاق شد' ,'md')
Pin(msg.chat_id,msg.reply_to_message_id, 1)
end
if matches == 'unpin' or matches == 'حذف سنجاق' then
sendText(msg.chat_id,msg.id, '⇜ پیام حذف سنجاق شد' ,'md')
Unpin(msg.chat_id)
end
if matches and (matches:match('^demote (%d+)') or matches:match('^حذف مدیر (%d+)')) then
local user = matches:match('demote (%d+)') or matches:match('^حذف مدیر (%d+)')
redis:srem('ModList:'..msg.chat_id,user)
SendMetion(msg.chat_id,user, msg.id, '⇜ کاربر : '..user..' عزل مقام شد', 10,string.len(user))
end
if matches == 'lock all' or matches == 'قفل همه' then
redis:set('MuteAll:'..msg.chat_id,true)
sendText(msg.chat_id, msg.id,'⇜ قفل همه فعال شد' ,'md')
end
if matches == 'autolock +' or matches == 'قفل خودکار +' then
redis:set('automuteall'..msg.chat_id,true)
sendText(msg.chat_id, msg.id,'⇜قفل خودکار فعال شد' ,'md')
end
if matches == 'autolock -' or matches == 'قفل خودکار -' then
redis:del('automuteall'..msg.chat_id)
sendText(msg.chat_id, msg.id,'⇜ قفل خودکار  غیر فعال شد' ,'md')
end

if matches == 'unlock all' or matches == 'بازکردن همه' then
redis:del('MuteAll:'..msg.chat_id)
local mutes =  redis:smembers('Mutes:'..msg.chat_id)
for k,v in pairs(mutes) do
redis:srem('MuteList:'..msg.chat_id,v)
mute(msg.chat_id,v,'Restricted',   {1, 1, 1, 1, 1,1})
end
sendText(msg.chat_id, msg.id,'⇜ قفل همه غیرفعال شد و تمام کاربران محدود شده توسط ربات آزاد شداند' ,'md')
end
if matches == 'clean modlist' or matches == 'پاکسازی مدیران' then
redis:del('ModList:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '⇜ لیست مدیران پاکسازی شد', 'md')
end
if matches1 and (matches1:match('^([Ss]etlock all) (.*)$') or matches1:match('^(قفل همه) (.*)$')) then
local matches1 = matches1:gsub("قفل همه", "setlock all")
local status = {string.match(matches1, "^([Ss]etlock all) (.*)$")}
if status[2] == 'rcd' or status[2] == 'محدودیت سازی' then
redis:set("Mute:All:Status:"..msg.chat_id,'Restricted') 
sendText(msg.chat_id, msg.id, '⇜ قفل همه در حالت محدود سازی قرار گرفت', 'md')
end
if status[2] == 'del' or status[2] == 'حذف پیام' then
redis:set("Mute:All:Status:"..msg.chat_id,'deletemsg') 
sendText(msg.chat_id, msg.id, '⇜ قفل همه در حالت حذف پیام قرار گرفت', 'md')
end
end
----------------
if matches and (matches1:match('^(autolock) (%d+):(%d+)-(%d+):(%d+)$') or matches1:match('^(قفل خودکار) (%d+):(%d+)-(%d+):(%d+)$')) then
local matches1 = matches1:gsub("قفل خودکار", "autolock")
local matches = {string.match(matches1, "^(autolock) (%d+):(%d+)-(%d+):(%d+)$")}
if redis:get('automuteall'..msg.chat_id) then
auto= 'فعال'
else
auto= 'غیرفعال'
end
local endtime = matches[4]..matches[5]
local endtime1 = matches[4]..":"..matches[5]
local starttime2 = matches[2]..":"..matches[3]
redis:set('EndTimeSee'..msg.chat_id,endtime1)
redis:set('StartTimeSee'..msg.chat_id,starttime2)
local starttime = matches[2]..matches[3]
if endtime1 == starttime2 then
test = [[⇜ شروع قفل خودکار نمیتواند با پایان آن یکی باشد]]
sendText(msg.chat_id, msg.id,test,"md")
else
redis:set('automutestart'..chat,starttime)
redis:set('automuteend'..chat,endtime)
test= '⇜ گروه شما به صورت خودکار از ساعت  * '..starttime2..'* قفل و در ساعت  *'..endtime1 ..'* باز میشود \n قفل خودکار : `'..auto..'`'
sendText(msg.chat_id, msg.id,test,"md")
  end
end
if matches == 'time sv' or matches == 'ساعت سرور' then
text ='⇜ ساعت :\n'..os.date("%H : %M")
sendText(msg.chat_id, msg.id,text,"md")
end
end
----
if is_Mod(msg) then
-----------Delete All-------------
if matches == 'delall' or matches == 'حذف پیام ها' then
function DelallByReply(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم پیام های خودم را پاک کنم", 'md')
return false
end
if private(msg.chat_id,Company.sender_user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", 'md')
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ تمام پیام های '..Company.sender_user_id..' پاکسازی شد', 16,string.len(Company.sender_user_id))
deleteMessagesFromUser(msg.chat_id,Company.sender_user_id) 
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),DelallByReply)  
end
end
if matches and (matches:match('^delall @(.*)') or matches:match('^حذف پیام ها @(.*)')) then
local username = matches:match('^delall @(.*)') or matches:match('^حذف پیام ها @(.*)')
function DelallByUsername(MaTaDoR,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
  sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم پیام های خودم را پاک کنم", "md")
return false
    end
  if private(msg.chat_id,Company.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", "md")
else
if Company.id then
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ تمام پیام های '..Company.id..' پاکسازی شد', 16,string.len(Company.id))
deleteMessagesFromUser(msg.chat_id,Company.id) 
else 
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
end
resolve_username(username,DelallByUsername)
end
if matches and (matches:match('^delall (%d+)') or matches:match('^حذف پیام ها (%d+)')) then
local user_id = matches:match('^delall (%d+)') or matches:match('^حذف پیام ها (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
  sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم پیام های خودم را پاک کنم", "md")
return false
    end
  if private(msg.chat_id,user_id) then
print '                      Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم پیام های یک فرد دارای  مقام را پاک کنم ", "md")   
else
SendMetion(msg.chat_id,user_id, msg.id, '⇜ تمام پیام های '..user_id..' پاکسازی شد', 16,string.len(user_id))
deleteMessagesFromUser(msg.chat_id,user_id) 
end
end
---------------------------------
if matches == 'viplist' or matches == 'لیست ویژه' then
local list = redis:smembers('Vip:'..msg.chat_id)
local t = '⇜ کاربران ویژه :\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n⇜ شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nاطلاعات 377450049"
if #list == 0 then
t = 'لیست کاربران ویژه خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if matches == 'banlist' or matches == 'لیست مسدود' then
local list = redis:smembers('BanUser:'..msg.chat_id)
local t = '⇜ کاربران محروم :\n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n⇜ شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nاطلاعات 377450049"
if #list == 0 then
t = 'لیست کاربران محدود خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if matches == 'clean banlist' or matches == 'پاکسازی مسدود' then
local function Clean(MaTaDoR,Company)
for k,v in pairs(Company.members) do
redis:del('BanUser:'..msg.chat_id)
RemoveFromBanList(msg.chat_id, v.user_id) 
end
end
sendText(msg.chat_id, msg.id,  '⇜ تمام کابران محروم شده از لیست محرومین حذف شداند ', 'md')
getChannelMembers(msg.chat_id, "Banned", 0, 100000000000,Clean)
end
 if matches == 'clean mutelist'  then
local mute = redis:smembers('MuteList:'..msg.chat_id)
for k,v in pairs(mute) do
redis:del('MuteList:'..msg.chat_id)
mute(msg.chat_id, v,'Restricted',   {1, 0, 0, 0, 0,0})
end
sendText(msg.chat_id, msg.id,  '⇜ تمام افراد محدود شده ازاد شداند ', 'md')
end
if matches == 'clean bots' or matches == 'پاکسازی ربات'  then
local function CleanBot(MaTaDoR,Company)
for k,v in pairs(Company.members) do
if tonumber(v.user_id) == tonumber(TD_ID) then
return false
end
 if private(msg.chat_id,v.user_id) then
print '                      Private                          '
else
end
KickUser(msg.chat_id, v.user_id) 
end
end
local d = 0
for i = 1, 12 do
getChannelMembers(msg.chat_id, "Bots", 0, 100000000000,CleanBot)
end
sendText(msg.chat_id, msg.id,  '⇜ تمام ربات ها اخراج شداند', 'md')
end
if matches == 'setvip' or matches == 'ویژه' then
function SetVipByReply(MaTaDoR,Company)
if redis:sismember('Vip:'..msg.chat_id, Company.sender_user_id) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' از قبل در لیست افراد ویژه قرار داشت', 10,string.len(Company.sender_user_id))
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' به لیست افراد ویژه اضافه شده', 10,string.len(Company.sender_user_id))
redis:sadd('Vip:'..msg.chat_id, Company.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),SetVipByReply)
end
if matches and (matches:match('^setvip @(.*)') or matches:match('^ویژه @(.*)')) then
local username = matches:match('^setvip @(.*)') or matches:match('^ویژه @(.*)')
function SetVipByUsername(MaTaDoR,Company)
if Company.id then
print('SetVip\nBy : '..msg.sender_user_id..'\nUser : '..Company.id..'\nUserName : '..username)
if redis:sismember('Vip:'..msg.chat_id,Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' از قبل در لیست افراد ویژه قرار داشت', 10,string.len(Company.id))
else
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' به لیست افراد ویژه اضافه شده', 10,string.len(Company.id))
redis:sadd('Vip:'..msg.chat_id, Company.id)
end
else 
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,SetVipByUsername)
end 
if matches == 'clean viplist' or matches == 'پاکسازی ویژه' then
redis:del('Vip:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '⇜ لیست ویژه پاکسازی شد', 'md')
end
if matches == 'remvip' or matches == 'حذف ویژه' then
function RemVipByReply(MaTaDoR,Company)
if redis:sismember('Vip:'..msg.chat_id, Company.sender_user_id) then
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' از لیست ویژه خارج شد', 10,string.len(Company.id))
redis:srem('Vip:'..msg.chat_id, Company.sender_user_id)
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, '⇜ کاربر : '..Company.sender_user_id..' از قبل در لیست ویژه نبود', 10,string.len(Company.id))
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),RemVipByReply)
end
if matches and (matches:match('^remvip @(.*)') or matches:match('^حذف ویژه @(.*)')) then
local username = matches:match('^remvip @(.*)') or matches:match('^حذف ویژه @(.*)')
function RemVipByUsername(MaTaDoR,Company)
if Company.id then
print('RemVip\nBy : '..msg.sender_user_id..'\nUser : '..Company.id..'\nUserName : '..username)
if redis:sismember('Vip:'..msg.chat_id,Company.id) then
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' از لیست ویژه خارج شد', 10,string.len(Company.id))
redis:srem('Vip:'..msg.chat_id, Company.sender_user_id)
else
SendMetion(msg.chat_id,Company.id, msg.id, '⇜ کاربر : '..Company.id..' از قبل در لیست ویژه نبود', 10,string.len(Company.id))
end
else 
text = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,REmVipByUsername)
end 
if matches and (matches:match('^muteuser (%d+)$') or matches:match('^سکوت (%d+)$')) then
local mutess = matches:match('^muteuser (%d+)$') or matches:match('^سکوت (%d+)$')
if tonumber(mutess) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم خودم را محدود کنم ', 'md')
return false
end
if private(msg.chat_id,mutess) then
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم یک فرد داری مقام را محدود کنم ", 'md')
else
mute(msg.chat_id, mutess,'Restricted',   {1, 0, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,mutess)
SendMetion(msg.chat_id,mutess, msg.id, '⇜ کاربر : '..mutess..' در حالت سکوت قرار گرفت', 10,string.len(mutess))
end
end
if matches1 and (matches1:match('^([Ss]etflood) (.*)$') or matches1:match('^پیام مکرر (.*)$')) then
local matches1 = matches1:gsub("پیام مکرر", "setflood")
local status = {string.match(matches1, "^([Ss]etflood) (.*)$")}
if status[2] == 'kick' or status[2] == 'اخراج' then
redis:set("Flood:Status:"..msg.chat_id,'kickuser') 
sendText(msg.chat_id, msg.id, 'وضعیت ارسال پیام مکرر بر روی اخراج کاربر قرار گرفت', 'md')
end
if status[2] == 'mute' or status[2] == 'سکوت' then
redis:set("Flood:Status:"..msg.chat_id,'muteuser') 
sendText(msg.chat_id, msg.id, 'وضعیت ارسال پیام مکرر بر روی سکوت کاربر قرار گرفت', 'md')
end
if status[2] == 'del' or status[2] == 'حذف' then
redis:set("Flood:Status:"..msg.chat_id,'deletemsg') 
sendText(msg.chat_id, msg.id, 'وضعیت ارسال پیام مکرر بر روی حذف کلی پیام کاربر قرار گرفت قرار گرفت', 'md')
end
end
if matches and (matches:match('^muteuser (%d+)$') or matches:match('^سکوت (%d+)$')) then
local times = matches:match('^muteuser (%d+)$')  or matches:match('^سکوت (%d+)$')
time = times * 3600
local function Restricted(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم خودم را محدود کنم ', 'md')
return false
end
if private(msg.chat_id,Company.sender_user_id) then
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم یک فرد داری مقام را محدود کنم ", 'md')
else
mute(msg.chat_id, Company.sender_user_id,'Restricted',   {1,msg.date+time, 0, 0, 0,0})
redis:sadd('MuteList:'..msg.chat_id,Company.sender_user_id)
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "⇜ کاربر "..(Company.sender_user_id or 000).." در حالت سکوت قرار گرفت برای "..times.." ساعت", 8,string.len(Company.sender_user_id))
end
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if matches == 'unmuteuser' or matches == 'حذف سکوت' then
function Restricted(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,Company.sender_user_id)
mute(msg.chat_id,Company.sender_user_id,'Restricted',   {1, 1, 1, 1, 1,1})
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "⇜ کاربر "..(Company.sender_user_id or 0000000).." از حالت سکوت خارج شد", 8,string.len(Company.sender_user_id))
end
if tonumber(msg.reply_to_message_id) == 0 then
else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),Restricted)  
end
end
if matches and (matches:match('^unmuteuser (%d+)$') or matches:match('^حذف سکوت (%d+)$')) then
local mutes =  matches:match('^unmuteuser (%d+)$') or matches:match('^حذف سکوت (%d+)$')
if tonumber(mutes) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('MuteList:'..msg.chat_id,mutes)
mute(msg.chat_id, mutes,'Restricted',   {1, 1, 1, 1, 1,1})
SendMetion(msg.chat_id,mutes, msg.id, "⇜ کاربر "..mutes.." از حالت سکوت خارج شد", 8,string.len(mutes))
end
if matches == 'setlink' or matches == 'تنظیم لینک' and tonumber(msg.reply_to_message_id) > 0 then
function GeTLink(MaTaDoR,Company)
local getlink = Company.content.text or Company.content.caption
for link in getlink:gmatch("(https://t.me/joinchat/%S+)") or getlink:gmatch("t.me", "telegram.me") do
redis:set('Link:'..msg.chat_id,link)
print(link)
end
sendText(msg.chat_id, msg.id,"⇜ لینک گروه ذخیره شد",  'md' )
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GeTLink)
end
if matches == 'remlink' or matches == 'حذف لینک' then
redis:del('Link:'..msg.chat_id)
sendText(msg.chat_id, msg.id,"⇜ لینک گروه حذف شد",  'md' )
end
if matches == 'ban' or matches == 'مسدود' and tonumber(msg.reply_to_message_id) > 0 then
function BanByReply(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"⇜ من نمیتوانم خودم را محدود کنم",  'md' )
return false
end
  if private(msg.chat_id,Company.sender_user_id) then
print '                     Private                          '
  sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
    else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "⇜ کاربر "..Company.sender_user_id.." مسدود شد", 8,string.len(Company.sender_user_id))
redis:sadd('BanUser:'..msg.chat_id,Company.sender_user_id)
KickUser(msg.chat_id,Company.sender_user_id)
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),BanByReply)
end
  if matches == 'clean filterlist' or matches == 'پاکسازی فیلتر' then
redis:del('Filters:'..msg.chat_id)
sendText(msg.chat_id, msg.id,  '⇜ لیست فیلتر پاکسازی شد', 'md')
end
if matches == 'filterlist' or matches == 'لیست فیلتر' then
local list = redis:smembers('Filters:'..msg.chat_id)
local t = '⇜ لیست کلمات فیلتر شده \n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
if #list == 0 then
t = '⇜ لیست کلمات فیلتر شده خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if matches == 'mutelist' or matches == 'لیست سکوت' then
local list = redis:smembers('MuteList:'..msg.chat_id)
local t = '⇜ Mute List \n'
for k,v in pairs(list) do
t = t..k.." - *"..v.."*\n" 
end
t = t.."\n\n⇜ شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nاطلاعات 377450049"
if #list == 0 then
t = 'لیست افراد ساکت شده خالی است'
end
sendText(msg.chat_id, msg.id,t, 'md')
end
if matches == 'clean warnlist' or matches == 'پاکسازی اخطار' then
redis:del(msg.chat_id..':warn')
sendText(msg.chat_id, msg.id,'لیست اخطار ها پاکسازی شد', 'md')
end
if matches == "warnlist" or matches == "لیست اخطار" then
local comn = redis:hkeys(msg.chat_id..':warn')
local t = 'لیست اخطار ها :\n'
for k,v in pairs (comn) do
local cont = redis:hget(msg.chat_id..':warn', v)
t = t..k..'- '..v..' تعداد اخطار  : '..(cont - 1)..'\n'
end
t = t.."\n\n⇜ شما میتوانید از دستور زیر برای دیدن کاربر استفاده کنید !\nاطلاعات 377450049"
if #comn == 0 then
t = 'The list is empty'
end 
sendText(msg.chat_id, msg.id,t, 'md')
end
if matches and (matches:match('^unban (%d+)') or matches:match('^حذف مسدود (%d+)')) then
local user_id = matches:match('^unban (%d+)') or matches:match('^حذف مسدود (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('BanUser:'..msg.chat_id,user_id)
RemoveFromBanList(msg.chat_id,user_id)
SendMetion(msg.chat_id,user_id, msg.id, "⇜ کاربر "..(user_id or 021).." از لیست محرومین حذف شد", 8,string.len(user_id))
end
if matches and (matches:match('^ban (%d+)') or matches:match('^مسدود (%d+)')) then
local user_id = matches:match('^ban (%d+)') or matches:match('^مسدود (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"⇜ من نمیتوانم خودم را مسدود کنم",  'md' )
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
else
redis:sadd('BanUser:'..msg.chat_id,user_id)
KickUser(msg.chat_id,user_id)
sendText(msg.chat_id, msg.id, '⇜ کاربر `'..user_id..'` مسدود شد', 'md')
end
end
if matches and (matches:match('^unban @(.*)') or matches:match('^حذف مسدود @(.*)')) then
local username = matches:match('unban @(.*)') or matches:match('^حذف مسدود @(.*)')
function UnBanByUserName(MaTaDoR,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if Company.id then
print('UserID : '..Company.id..'\nUserName : @'..username)
redis:srem('BanUser:'..msg.chat_id,Company.id)
SendMetion(msg.chat_id,Company.id, msg.id, "⇜ کاربر "..(Company.id or 021).." از لیست محرومین حذف شد", 8,string.len(Company.id))
else 
sendText(msg.chat_id, msg.id, '⇜ کاربر یافت نشد',  'md')

end
print('Send')
end
resolve_username(username,UnBanByUserName)
end
if matches == 'unban' or matches == 'حذف مسدود' and tonumber(msg.reply_to_message_id) > 0 then
function UnBan_by_reply(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
redis:srem('BanUser:'..msg.chat_id,Company.sender_user_id)
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "⇜ کاربر "..Company.sender_user_id.." از لست محرومین حذف شد",8,string.len(Company.sender_user_id))
RemoveFromBanList(msg.chat_id,Company.sender_user_id)
 end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnBan_by_reply)
end

if matches and (matches:match('^ban @(.*)') or matches:match('^مسدود @(.*)')) then
local username = matches:match('^ban @(.*)') or matches:match('^مسدود @(.*)')
print '                     Private                          '
function BanByUserName(MaTaDoR,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"⇜ من نمیتوانم خودم را مسدود کنم",  'md' )
return false
end
if private(msg.chat_id,Company.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم یک کاربر دارای مقام را مسدود کنم", 'md')
else
if Company.id then
redis:sadd('BanUser:'..msg.chat_id,Company.id)
KickUser(msg.chat_id,Company.id)
SendMetion(msg.chat_id,Company.id, msg.id, "⇜ کاربر "..Company.id.." مسدود شد", 8,string.len(Company.id))
else 
t = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id, t,  'md')
end
end
end
resolve_username(username,BanByUserName)
end
if matches== 'kick' or matches== 'اخراج' and tonumber(msg.reply_to_message_id) > 0 then
function kick_by_reply(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"⇜ من نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,Company.sender_user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, "⇜ کاربر "..Company.sender_user_id.." اخراج شد",8,string.len(Company.sender_user_id))
KickUser(msg.chat_id,Company.sender_user_id)
RemoveFromBanList(msg.chat_id,Company.sender_user_id)
 end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),kick_by_reply)
end
if matches and (matches:match('^kick @(.*)') or matches:match('^اخراج @(.*)')) then
local username = matches:match('^kick @(.*)') or matches:match('^اخراج @(.*)')
function KickByUserName(MaTaDoR,Company)
if tonumber(Company.id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"⇜ من نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,Company.id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
if Company.id then
KickUser(msg.chat_id,Company.id)
RemoveFromBanList(msg.chat_id,Company.id)
SendMetion(msg.chat_id,Company.id, msg.id, "⇜ کاربر "..Company.id.." اخراج شد", 8,string.len(Company.id))
else 
txtt = '⇜ کاربر یافت نشد'
sendText(msg.chat_id, msg.id,txtt,  'md')
end
end
end
resolve_username(username,KickByUserName)
end
if matches == 'clean res' or matches == 'پاکسازی محدود' then
local function pro(arg,data)
if redis:get("Check:Restricted:"..msg.chat_id) then
text = '⇜ هر 5دقیقه یکبار ممکن است'
end
for k,v in pairs(data.members) do
redis:del('MuteAll:'..msg.chat_id)
 mute(msg.chat_id, v.user_id,'Restricted',    {1, 1, 1, 1, 1,1})
   redis:setex("Check:Restricted:"..msg.chat_id,350,true)
end
end
getChannelMembers(msg.chat_id,"Recent", 0, 100000000000,pro)
sendText(msg.chat_id, msg.id,'⇜ افراد محدود پاک شدند' ,'md')
end 
if matches and (matches:match('^kick (%d+)') or matches:match('^اخراج (%d+)')) then
local user_id = matches:match('^kick (%d+)') or matches:match('^اخراج (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,"⇜ من نمیتوانم خودم را اخراج کنم",  'md' )
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم یک فرد دارای مقام را اخراج کنم", 'md')
else
KickUser(msg.chat_id,user_id)
text= '⇜ کاربر '..user_id..' اخراج شد'
SendMetion(msg.chat_id,user_id, msg.id, text,8, string.len(user_id))
RemoveFromBanList(msg.chat_id,user_id)
end
end
if matches and (matches:match('^setflood (%d+)') or matches:match('^پیام مکرر (%d+)')) then
local num = matches:match('^setflood (%d+)') or matches:match('^پیام مکرر (%d+)')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, '⇜ عددی بزرگتر از *۲* بکار ببرید','md')
else
redis:set('Flood:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '⇜ حداکثر پیام مکرر تنطیم شد به :  *'..num..'*', 'md')
end
end
if matches and (matches:match('^warnmax (%d+)') or matches:match('^حداکثر اخطار (%d+)')) then
local num = matches:match('^warnmax (%d+)') or matches:match('^حداکثر اخطار (%d+)')
if tonumber(num) < 2 then
sendText(msg.chat_id, msg.id, '⇜ عددی بزرگتر از *۲* بکار ببرید','md')
else
redis:set('Warn:Max:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '⇜ حداکثر اخطار تنظیم شد به *'..num..'*', 'md')
end
end
if matches and (matches:match('^setspam (%d+)') or matches:match('^تعداد کارکتر (%d+)')) then
local num = matches:match('^setspam (%d+)') or matches:match('^تعداد کارکتر  (%d+)')
if tonumber(num) < 40 then
sendText(msg.chat_id, msg.id, '⇜ عددی بزرگتر از *40* بکار ببرید','md')
else
if tonumber(num) > 4096 then
sendText(msg.chat_id, msg.id, '⇜ عددی کوچکتر از *۴۰۹۶* را بکار ببرید','md')
else
redis:set('NUM_CH_MAX:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '⇜ حساسیت به پیام های طولانی تنظیم شد به : *'..num..'*', 'md')
end
end
end
if matches and (matches:match('^setfloodtime (%d+)') or matches:match('^زمان برسی (%d+)')) then
local num = matches:match('^setfloodtime (%d+)') or matches:match('^زمان برسی (%d+)')
if tonumber(num) < 1 then
sendText(msg.chat_id, msg.id, '⇜ `زمان بررسی باید بیشتر از` *1* `باشد`','md')
else
redis:set('Flood:Time:'..msg.chat_id,num)
sendText(msg.chat_id, msg.id, '⇜ `زمان برسی تنظیم شد ` *'..num..'*', 'md')
end
end
if matches and (matches:match('^rmsg (%d+)$') or matches:match('^حذف (%d+)$')) then
local limit = tonumber(matches:match('^rmsg (%d+)$'))
if limit > 100 and limit < 0 then
sendText(msg.chat_id, msg.id, '⇜ *عددی بین * [`1-100`] را انتخاب کنید', 'md')
else
local function cb(arg,data)
for k,v in pairs(data.messages) do
deleteMessages(msg.chat_id,{[0] =v.id})
end
end
getChatHistory(msg.chat_id,msg.id, 0,  limit,cb)
sendText(msg.chat_id, msg.id, '⇜ تعداد ('..limit..') پیام پاکسازی شد', 'md')
end
end
if matches == 'menu' or matches == 'فهرست' then
function GetPanel(MaTaDoR,Company)
if Company.results and Company.results[0] then
sendInline(msg.chat_id,msg.id, 0, 1, Company.inline_query_id,Company.results[0].id)
else
sendText(msg.chat_id, msg.id, '⇜ مشکل فنی در ربات Api','md')
end
end
get(BotHelper, msg.chat_id, 0, 0, msg.chat_id,0, GetPanel)
end
if matches == 'settings' or matches == 'تنظیمات' then
local function Get(MaTaDoR, Companys)
local function GetName(MaTaDoR, Company)
local chat = msg.chat_id
if redis:get('Welcome:'..msg.chat_id) == 'enable' then
welcome = '`[✓]`'
else
welcome = '`[✘]`'
end
if redis:get('Lock:Edit'..chat) then
edit = '`[✓]`'
else
edit = '`[✘]`'
end
if redis:get("Lock:Cmd"..msg.chat_id) then
cmd = '`[✓]`'
else
cmd = '`[✘]`'
end
if redis:get('Lock:Link'..chat) then
Link = '`[✓]`'
else
Link = '`[✘]`' 
end
if redis:get('Lock:Tag:'..chat) then
tag = '`[✓]`'
else
tag = '`[✘]`' 
end
if redis:get('Lock:HashTag:'..chat) then
hashtag = '`[✓]`'
else
hashtag = '`[✘]`' 
end
if redis:get('Lock:Video_note:'..chat) then
video_note = '`[✓]`'
else
video_note = '`[✘]`' 
end
if redis:get('Lock:Inline:'..chat) then
inline = '`[✓]`'
else
inline = '`[✘]`' 
end
if redis:get("Flood:Status:"..msg.chat_id) then
if redis:get("Flood:Status:"..msg.chat_id) == "kickuser" then
Status = '`اخراج کاربر`'
elseif redis:get("Flood:Status:"..msg.chat_id) == "muteuser" then
Status = '`سکوت کاربر`'
elseif redis:get("Flood:Status:"..msg.chat_id) == "deletemsg" then
Status = '`حذف پیام`'
end
else
Status = '`تنظیم نشده`'
end
if redis:get('Lock:Pin:'..chat) then
pin = '`[✓]`'
else
pin = '`[✘]`' 
end
if redis:get('Lock:Forward:'..chat) then
fwd = '`[✓]`'
else
fwd = '`[✘]`' 
end
if redis:get('Lock:Bot:'..chat) then
bot = '`[✓]`'
else
bot = '`[✘]`' 
end
if redis:get('Spam:Lock:'..chat) then
spam = '`[✓]`'
else
spam = '`[✘]`' 
end
if redis:get('Lock:Arabic:'..chat) then
arabic = '`[✓]`'
else
arabic = '`[✘]`' 
end
if redis:get('Lock:English:'..chat) then
en = '`[✓]`'
else
en = '`[✘]`' 
end
if redis:get('Lock:Markdown:'..chat) then
mak = '`[✓]`'
else
mak = '`[✘]`' 
end
if redis:get('Lock:TGservise:'..chat) then
tg = '`[✓]`'
else
tg = '`[✘]`' 
end
if redis:get('Lock:Sticker:'..chat) then
sticker = '`[✓]`'
else
sticker = '`[✘]`' 
end
if redis:get('CheckBot:'..msg.chat_id) then
TD = '`[✓]`'
else
TD = '`[✘]`'
end
if redis:get('automuteall'..chat_id) then
auto= '`[✓]`'
else
auto= '`[✘]`'
end
if redis:get('Mute:Text:'..msg.chat_id) then
txts = '`[✓]`'
else
txts = '`[✘]`'
end
if redis:get('Mute:Caption:'..msg.chat_id) then
caption = '`[✓]`'
else
caption = '`[✘]`'
end
if redis:get('Mute:Reply:'..chat) then
rep = '`[✓]`'
else
rep = '`[✘]`' 
end
if redis:get('Mute:Contact:'..msg.chat_id) then
contact = '`[✓]`'
else
contact = '`[✘]`'
end
if redis:get('Mute:Document:'..msg.chat_id) then
document = '`[✓]`'
else
document = '`[✘]`'
end
if redis:get('Mute:Location:'..msg.chat_id) then
location = '`[✓]`'
else
location = '`[✘]`'
end
if redis:get('Mute:Voice:'..msg.chat_id) then
voice = '`[✓]`'
else
voice = '`[✘]`'
end
if redis:get('Mute:Photo:'..msg.chat_id) then
photo = '`[✓]`'
else
photo = '`[✘]`'
end
if redis:get('Mute:Game:'..msg.chat_id) then
game = '`[✓]`'
else
game = '`[✘]`'
end
if redis:get('MuteAll:'..chat) then
muteall = '`[✓]`'
else
muteall = '`[✘]`' 
end
if redis:get('Lock:Flood:'..msg.chat_id) then
flood = '`[✓]`'
else
flood = '`[✘]`'
end
if redis:get('Mute:Video:'..msg.chat_id) then
video = '`[✓]`'
else
video = '`[✘]`'
end
if redis:get('Mute:Music:'..msg.chat_id) then
music = '`[✓]`'
else
music = '`[✘]`'
end
if redis:get('Mute:Gif:'..msg.chat_id) then
gif = '`[✓]`'
else
gif = '`[✘]`'
end
local expire = redis:ttl("ExpireData:"..msg.chat_id)
if expire == -1 then
EXPIRE = "`نامحدود`"
else
local d = math.floor(expire / day ) + 1
EXPIRE = "`"..d.." روز`"
end
------------------------More Settings-------------------------
local stop = (redis:get('EndTimeSee'..msg.chat_id) or 'nil')
local start = (redis:get('StartTimeSee'..msg.chat_id) or 'nil')
local Text = '⚙️ *تنظیمات گروه* `('..Company.title..')` *:*\n\n┑ 🔸*لینک :* '..Link..'\n┥ 🔹*ویرایش :* '..edit..'\n┥ 🔸*نام‌کاربری :* '..tag..'\n┥ 🔹*هشتگ :* '..hashtag..'\n┥ 🔸*دکمه‌شیشه‌ای :* '..inline..'\n┥ 🔹*فیلم‌سلفی :* '..video_note..'\n┥ 🔸*سنجاق :* '..pin..'\n┥ 🔹*استیکر :* '..sticker..'\n┥ 🔸*فورواد :* '..fwd..'\n┥ 🔹*فارسی :* '..arabic..'\n┥ 🔸*انگلیسی :* '..en..'\n┥ 🔹*سرویس‌تلگرام :* '..tg..'\n┙ 🔸*فونت :* '..mak..'\n\n〘     💠 _تنظیمات رسانه_      〙\n\n┑ 🔹*رسانه‌ها :* '..caption..'\n┥ 🔸*عکس :* '..photo..'\n┥ 🔹*آهنگ :* '..music..'\n┥ 🔸*ویس :* '..voice..'\n┥ 🔹*فایل :* '..document..'\n┥ 🔸*فیلم :* '..video..'\n┥ 🔹*بازی :* '..game..'\n┥ 🔸*موقعیت‌مکانی :* '..location..'\n┥ 🔹*گیف :* '..gif..'\n┥ 🔸*مخاطب :* '..contact..'\n┙ 🔹*متن :* '..txts..'\n\n〘     ♨️ _تنظیمات بیشتر_      〙\n\n┑ 🔸*گروه :* '..muteall..'\n┥ 🔹*ریپلای :* '..rep..'\n┥ 🔸*ربات :* '..bot..'\n┥ 🔹*دستورات :* '..cmd..'\n┥ 🔸*هرزنامه :* '..spam..'\n┥ 🔹*پیام‌مکرر :* '..flood..'\n┙ 🔸*خوشآمد‌گوی :* '..welcome..'\n\n┑ 🔹*قفل خودکار  :* '..auto..'\n┥ 🔹*زمان شروع :* '..start..'\n┙ 🔸*زمان پایان :* '..stop..'\n\n┑ 🔹*موقعیت پیام‌مکرر :* '..Status..'\n┥ 🔸*زمان‌برسی پیام‌مکرر :* '..TIME_CHECK..'\n┥ 🔹*حداکثر پیام‌مکرر :* '..NUM_MSG_MAX..'\n┥ 🔸*حداکثر هرزنامه :* '..NUM_CH_MAX..'\n┙ 🔹*حداکثر اخطار :* '..warn..'\n\n┥ 📅*تاریخ انقضا :* '..EXPIRE..'\n\n┑ 💻*سازنده ربات :* '..check_markdown(UserSudo)..'\n┙ 🌐*کانال ما :* '..check_markdown(Channel)..'\n'
sendText(msg.chat_id, msg.id, Text, 'md')
end
GetChat(msg.chat_id,GetName)
end
getChannelFull(msg.chat_id,Get)
end
if matches == 'welcome +' or matches == 'خوشآمد +' then
if redis:get('Welcome:'..msg.chat_id) == 'enable' then
sendText(msg.chat_id, msg.id,'⇜ خوشآمد از قبل فعال بود' ,'md')
else
sendText(msg.chat_id, msg.id,'⇜ خوشآمد فعال شد' ,'md')
redis:del('Welcome:'..msg.chat_id,'disable')
redis:set('Welcome:'..msg.chat_id,'enable')
end
end
if matches == 'welcome -' or matches == 'خوشآمد -' then
if redis:get('Welcome:'..msg.chat_id) then
sendText(msg.chat_id, msg.id,'⇜ خوشآمد گروه غیر فعال شد' ,'md')
redis:set('Welcome:'..msg.chat_id,'disable')
redis:del('Welcome:'..msg.chat_id,'enable')
else
sendText(msg.chat_id, msg.id,'⇜ خوشآمد گروه از قبل فعال نبود' ,'md')
end
end
-----------------------------------------------Locks------------------------------------------------
if matches == 'lock cmd' or matches == 'قفل دستورات' then
if redis:get('Lock:Cmd'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #دستورات *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #دستورات *فعال شد* 🔒' , 'md')
redis:set('Lock:Cmd'..msg.chat_id,true)
end
end
if matches == 'unlock cmd' or matches == 'بازکردن دستورات' then
if redis:get('Lock:Cmd'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #دستورات *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Cmd'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #دستورات *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock markdown' or matches == 'قفل فونت' then
if redis:get('Lock:Markdown:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فونت *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فونت *فعال شد* 🔒' , 'md')
redis:set('Lock:Markdown:'..msg.chat_id,true)
end
end
if matches == 'unlock markdown' or matches == 'بازکردن فونت' then
if redis:get('Lock:Markdown:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فونت *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Markdown:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فونت *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock caption' or matches == 'قفل رسانه' then
if redis:get('Mute:Caption:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #رسانه *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #رسانه *فعال شد* 🔒' , 'md')
redis:set('Mute:Caption:'..msg.chat_id,true)
end
end
if matches == 'unlock caption' or matches == 'بازکردن رسانه' then
if redis:get('Mute:Caption:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #رسانه *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Caption:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #رسانه *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock reply' or matches == 'قفل ریپلای' then
if redis:get('Mute:Reply:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ریپلای *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ریپلای *فعال شد* 🔒' , 'md')
redis:set('Mute:Reply:'..msg.chat_id,true)
end
end
if matches == 'unlock reply' or matches == 'بازکردن ریپلای' then
if redis:get('Mute:Reply:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ریپلای *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Reply:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ریپلای *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock link' or matches == 'قفل لینک' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #لینک *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #لینک *فعال شد* 🔒' , 'md')
redis:set('Lock:Link'..msg.chat_id,true)
end
end
if matches == 'unlock link' or matches == 'بازکردن لینک' then
if redis:get('Lock:Link'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #لینک *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Link'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #لینک *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock tag' or matches == 'قفل تگ' then
if redis:get('Lock:Tag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #نام کاربر *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #نام کاربر *فعال شد* 🔒' , 'md')
redis:set('Lock:Tag:'..msg.chat_id,true)
end
end
if matches == 'unlock tag' or matches == 'بازکردن تگ' then
if redis:get('Lock:Tag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #نام کاربر *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Tag:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #نام کاربر *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock hashtag' or matches == 'قفل هشتگ' then
if redis:get('Lock:HashTag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #هشتگ *ازقبل فعال بود* ❌🔐' , 'md')
else 
sendText(msg.chat_id, msg.id, '⇜ *قفل* #هشتگ *فعال شد* 🔒' , 'md')
redis:set('Lock:HashTag:'..msg.chat_id,true)
end
end
if matches == 'unlock hashtag' or matches == 'بازکردن هشتگ' then
if redis:get('Lock:HashTag:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #هشتگ *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:HashTag:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #هشتگ *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock self' or matches == 'قفل سلفی' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فیلم سلفی *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فیلم سلفی *فعال شد* 🔒' , 'md')
redis:set('Lock:Video_note:'..msg.chat_id,true)
end
end
if matches == 'unlock self' or matches == 'بازکردن سلفی' then
if redis:get('Lock:Video_note:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فیلم سلفی *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Video_note:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فیلم سلفی *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock spam' or matches == 'قفل هرزنامه' then
if redis:get('Spam:Lock:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #هرزنامه *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #هرزنامه *فعال شد* 🔒' , 'md')
redis:set('Spam:Lock:'..msg.chat_id,true)
end
end
if matches == 'unlock spam' or matches == 'بازکردن هرزنامه' then
if redis:get('Spam:Lock:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #هرزنامه *غیرفعال شد* 🔓' , 'md')
redis:del('Spam:Lock:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #هرزنامه *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock inline' or matches == 'قفل دکمه شیشه ای' then
if redis:get('Lock:Inline:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #دکمه شیشه ای *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #دکمه شیشه ای *فعال شد* 🔒' , 'md')
redis:set('Lock:Inline:'..msg.chat_id,true)
end
end
if matches == 'unlock inline' or matches == 'بازکردن دکمه شیشه ای' then
if redis:get('Lock:Inline:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #دکمه شیشه ای *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Inline:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #دکمه شیشه ای *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock flood' or matches == 'قفل پیام مکرر' then
if redis:get('Lock:Flood:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #پیام مکرر *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #پیام مکرر *فعال شد* 🔒' , 'md')
redis:set('Lock:Flood:'..msg.chat_id,true)
end
end
if matches == 'unlock flood' or matches == 'بازکردن پیام مکرر' then
if redis:get('Lock:Flood:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #پیام مکرر *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Flood:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #پیام مکرر *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock forward' or matches == 'قفل فوروارد' then
if redis:get('Lock:Forward:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فوروارد *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فوروارد *فعال شد* 🔒' , 'md')
redis:set('Lock:Forward:'..msg.chat_id,true)
end
end
if matches == 'unlock forward' or matches == 'بازکردن فوروارد' then
if redis:get('Lock:Forward:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فوروارد *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Forward:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فوروارد *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock farsi' or matches == 'قفل فارسی' then
if redis:get('Lock:Arabic:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فارسی *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فارسی *فعال شد* 🔒' , 'md')
redis:set('Lock:Arabic:'..msg.chat_id,true)
end
end
if matches == 'unlock farsi' or matches == 'بازکردن فارسی' then
if redis:get('Lock:Arabic:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فارسی *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Arabic:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فارسی *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock bot' or matches == 'قفل ربات' then
if redis:get('Lock:Bot:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ربات *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ربات *فعال شد* 🔒' , 'md')
redis:set('Lock:Bot:'..msg.chat_id,true)
end
end
if matches == 'unlock bot' or matches == 'بازکردن ربات'then
if redis:get('Lock:Bot:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ربات *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Bot:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ربات *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock edit' or matches == 'قفل ویرایش' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ویرایش *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ویرایش *فعال شد* 🔒' , 'md')
redis:set('Lock:Edit'..msg.chat_id,true)
end
end
if matches == 'unlock edit' or matches == 'بازکردن ویرایش' then
if redis:get('Lock:Edit'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ویرایش *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Edit'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ویرایش *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock english' or matches == 'قفل انگلیسی' then
if redis:get('Lock:English:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #انگلیسی *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #انگلیسی *فعال شد* 🔒' , 'md')
redis:set('Lock:English:'..msg.chat_id,true)
end
end
if matches == 'unlock english' or matches == 'بازکردن انگلیسی' then
if redis:get('Lock:English:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #انگلیسی *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:English:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #انگلیسی *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock tgservic' or matches == 'قفل سرویس' then
if redis:get('Lock:TGservise:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #سرویس *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #سرویس *فعال شد* 🔒' , 'md')
redis:set('Lock:TGservise:'..msg.chat_id,true)
end
end
if matches == 'unlock tgservic' or matches == 'بازکردن سرویس' then
if redis:get('Lock:TGservise:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #سرویس *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:TGservise:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #سرویس *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock sticker' or matches == 'قفل استیکر' then
if redis:get('Lock:Sticker:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #استیکر *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #استیکر *فعال شد* 🔒' , 'md')
redis:set('Lock:Sticker:'..msg.chat_id,true)
end
end
if matches == 'unlock sticker' or matches == 'بازکردن استیکر' then
if redis:get('Lock:Sticker:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #استیکر *غیرفعال شد* 🔓' , 'md')
redis:del('Lock:Sticker:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #استیکر *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock text' or matches == 'قفل متن' then
if redis:get('Mute:Text:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #متن *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #متن *فعال شد* 🔒' , 'md')
redis:set('Mute:Text:'..msg.chat_id,true)
end
end
if matches == 'unlock text' or matches == 'بازکردن متن' then
if redis:get('Mute:Text:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #متن *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Text:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #متن *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock contact' or matches == 'قفل مخاطب' then
if redis:get('Mute:Contact:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #مخاطب *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #مخاطب *فعال شد* 🔒' , 'md')
redis:set('Mute:Contact:'..msg.chat_id,true)
end
end
if matches == 'unlock contact' or matches == 'بازکردن مخاطب' then
if redis:get('Mute:Contact:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #مخاطب *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Contact:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #مخاطب *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock document' or matches == 'قفل فایل' then
if redis:get('Mute:Document:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فایل *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فایل *فعال شد* 🔒' , 'md')
redis:set('Mute:Document:'..msg.chat_id,true)
end
end
if matches == 'unlock document' or matches == 'بازکردن فایل' then
if redis:get('Mute:Document:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فایل *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Document:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فایل *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock location' or matches == 'قفل موقعیت' then
if redis:get('Mute:Location:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #موقعیت *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #موقعیت *فعال شد* 🔒' , 'md')
redis:set('Mute:Location:'..msg.chat_id,true)
end
end
if matches == 'unlock location' or matches == 'بازکردن موقعیت' then
if redis:get('Mute:Location:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #موقعیت *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Location:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #موقعیت *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock voice' or matches == 'قفل ویس' then
if redis:get('Mute:Voice:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ویس *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ویس *فعال شد* 🔒' , 'md')
redis:set('Mute:Voice:'..msg.chat_id,true)
end
end
if matches == 'unlock voice' or matches == 'بازکردن ویس' then
if redis:get('Mute:Voice:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ویس *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Voice:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #ویس *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock photo' or matches == 'قفل عکس' then
if redis:get('Mute:Photo:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #عکس *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #عکس *فعال شد* 🔒' , 'md')
redis:set('Mute:Photo:'..msg.chat_id,true)
end
end
if matches == 'unlock photo' or matches == 'بازکردن عکس' then
if redis:get('Mute:Photo:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #عکس *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Photo:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #عکس *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock game' or matches == 'قفل بازی' then
if redis:get('Mute:Game:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #بازی *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #بازی *فعال شد* 🔒' , 'md')
redis:set('Mute:Game:'..msg.chat_id,true)
end
end
if matches == 'unlock game' or matches == 'بازکردن بازی' then
if redis:get('Mute:Game:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #بازی *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Game:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #بازی *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock video' or matches == 'قفل فیلم' then
if redis:get('Mute:Video:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فیلم *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فیلم *فعال شد* 🔒' , 'md')
redis:set('Mute:Video:'..msg.chat_id,true)
end
end
if matches == 'unlock video' or matches == 'بازکردن فیلم' then
if redis:get('Mute:Video:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فیلم *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Video:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #فیلم *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock music' or matches == 'قفل آهنگ' then
if redis:get('Mute:Music:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #آهنگ *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #آهنگ *فعال شد* 🔒' , 'md')
redis:set('Mute:Music:'..msg.chat_id,true)
end
end
if matches == 'unlock music' or matches == 'بازکردن آهنگ' then
if redis:get('Mute:Music:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #آهنگ *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Music:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #آهنگ *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
if matches == 'lock gif' or matches == 'قفل گیف' then
if redis:get('Mute:Gif:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #گیف *ازقبل فعال بود* ❌🔐' , 'md')
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #گیف *فعال شد* 🔒' , 'md')
redis:set('Mute:Gif:'..msg.chat_id,true)
end
end
if matches == 'unlock gif' or matches == 'بازکردن گیف' then
if redis:get('Mute:Gif:'..msg.chat_id) then
sendText(msg.chat_id, msg.id, '⇜ *قفل* #گیف *غیرفعال شد* 🔓' , 'md')
redis:del('Mute:Gif:'..msg.chat_id)
else
sendText(msg.chat_id, msg.id, '⇜ *قفل* #گیف *ازقبل غیرفعال بود* ❌🔐' , 'md')
end
end
----------------------------------------------------------------------------------
if matches1 and (matches1:match('^[Ss]etlink (.*)') or matches1:match('^تنظیم لینک (.*)')) then
local link = matches1:match('^[Ss]etlink (.*)') or matches1:match('^تنظیم لینک (.*)')
redis:set('Link:'..msg.chat_id,link)
sendText(msg.chat_id, msg.id,'⇜ لینک گروه با موفقیت ثبت شد', 'md')
end
if matches1 and (matches1:match('^[Ss]etwelcome (.*)') or matches1:match('^تنظیم خوشآمد (.*)')) then
local wel = matches1:match('^[Ss]etwelcome (.*)') or matches1:match('^تنظیم خوشآمد (.*)')
redis:set('Text:Welcome:'..msg.chat_id,wel)
sendText(msg.chat_id, msg.id,'⇜ خوشآمد گروه با موفقیت ثبت شد', 'md')
end
if matches1 and (matches1:match('^[Ss]etrules (.*)') or matches1:match('^تنظیم قوانین (.*)')) then
local rules = matches1:match('^[Ss]etrules (.*)') or matches1:match('^تنظیم قوانین (.*)')
redis:set('Rules:'..msg.chat_id,rules)
sendText(msg.chat_id, msg.id,'⇜ قوانین گروه با موفقیت ثبت شد', 'md')
end

-----------------------------------------------------------------------------------------------------------------------------------------------------
if matches and (matches:match('^filter +(.*)') or matches:match('^فیلتر +(.*)')) then
local word = matches:match('^filter +(.*)') or matches:match('^فیلتر +(.*)')
redis:sadd('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id, '⇜ کلمه `'..word..'` به لیست فیلتر اضافه شد', 'md')
end

if matches and (matches:match('^remfilter +(.*)') or matches:match('^حذف فیلتر +(.*)')) then
local word = matches:match('^remfilter +(.*)') or matches:match('^حذف فیلتر +(.*)')
redis:srem('Filters:'..msg.chat_id,word)
sendText(msg.chat_id, msg.id,'⇜ کلمه `'..word..'` از لیست فیلتر حذف شد', 'md')
end
if (matches == "warn" or matches == "اخطار") and tonumber(msg.reply_to_message_id) > 0 then
function WarnByReply(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,Company.sender_user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "من نمیتوانم به یک فرد دارای مقام اخطار بدهم", 'md')
else
 local hashwarn = msg.chat_id..':warn'
local warnhash = redis:hget(msg.chat_id..':warn',Company.sender_user_id) or 1
if tonumber(warnhash) == tonumber(warn) then
KickUser(msg.chat_id,Company.sender_user_id)
RemoveFromBanList(msg.chat_id,Company.sender_user_id)
text= "⇜ کاربر "..Company.sender_user_id.." به علت دریافت بیش از حد پیام از گروه اخراج شد \n اخطار ها : "..warnhash.."/"..warn..""
redis:hdel(hashwarn,Company.sender_user_id, '0')
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, text, 8, string.len(Company.sender_user_id))
else
local warnhash = redis:hget(msg.chat_id..':warn',Company.sender_user_id) or 1
 redis:hset(hashwarn,Company.sender_user_id, tonumber(warnhash) + 1)
text= "⇜ کاربر "..(Company.sender_user_id or '0000Null0000').."شما یک اخطار دریافت کردید \nتعداد اخطار های شما:" ..warnhash .. "/" .. warn .. ""
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, text, 8, string.len(Company.sender_user_id))
end
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),WarnByReply)
end
if matches and (matches:match('^warn (%d+)') or matches:match('^اخطار (%d+)')) then
local user_id = matches:match('^warn (%d+)') or matches:match('^اخطار (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,user_id) then
print '                     Private                          '
sendText(msg.chat_id, msg.id, "⇜ من نمیتوانم به یک فرد دارای مقام اخطار بدهم", 'md')
else
 local hashwarn = msg.chat_id..':warn'
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
if tonumber(warnhash) == tonumber(warn) then
KickUser(msg.chat_id,user_id)
RemoveFromBanList(msg.chat_id,user_id)
text= "⇜ کاربر "..user_id.." به علت دریافت بیش از حد اخطار از گروه اخراج شد \n اخطار ها : "..warnhash.."/"..warn..""
redis:hdel(hashwarn,user_id, '0')
SendMetion(msg.chat_id,user_id, msg.id, text, 8, string.len(user_id))
else
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
 redis:hset(hashwarn,user_id, tonumber(warnhash) + 1)
text= "⇜ کاربر " ..user_id.. " شما یک اخطار دریافت کردید\nتعداد اخطار های شما :" ..warnhash .. "/" .. warn .. ""
SendMetion(msg.chat_id,user_id, msg.id, text, 8, string.len(user_id))
end
end
end
if (matches == "unwarn" or matches == "حذف اخطار") and tonumber(msg.reply_to_message_id) > 0 then
function UnWarnByReply(MaTaDoR,Company)
if tonumber(Company.sender_user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام های خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,Company.sender_user_id) then
else
local warnhash = redis:hget(msg.chat_id..':warn',Company.sender_user_id) or 1
if tonumber(warnhash) == tonumber(1) then
text= "⇜ کاربر "..Company.sender_user_id.." هیچ اخطاری ندارد"
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, text, 8, string.len(Company.sender_user_id))
else
local warnhash = redis:hget(msg.chat_id..':warn',Company.sender_user_id)
local hashwarn = msg.chat_id..':warn'
redis:hdel(hashwarn,Company.sender_user_id,'0')
text= '⇜ کاربر '..Company.sender_user_id..' تمام اخطار هایش پاک شد'
SendMetion(msg.chat_id,Company.sender_user_id, msg.id, text, 8, string.len(Company.sender_user_id))
end
end
end
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),UnWarnByReply)
end
if matches and (matches:match('^unwarn (%d+)') or matches:match('^حذف اخطار (%d+)')) then
local user_id = matches:match('^unwarn (%d+)') or matches:match('^حذف اخطار (%d+)')
if tonumber(user_id) == tonumber(TD_ID) then
sendText(msg.chat_id, msg.id,  '⇜ من نمیتوانم پیام های خودم را چک کنم', 'md')
return false
end
if private(msg.chat_id,user_id) then
else
local warnhash = redis:hget(msg.chat_id..':warn',user_id) or 1
if tonumber(warnhash) == tonumber(1) then
text= "⇜ کاربر "..user_id.." هیچ اخطاری ندارد"
SendMetion(msg.chat_id,user_id, msg.id, text, 8, string.len(user_id))
else
local warnhash = redis:hget(msg.chat_id..':warn',user_id)
local hashwarn = msg.chat_id..':warn'
redis:hdel(hashwarn,user_id,'0')
text= '⇜ کاربر '..user_id..' تمام اخطار هایش پاک شد'
SendMetion(msg.chat_id,user_id, msg.id, text, 8, string.len(user_id))
end
end
end
------
end
------
if redis:get("Lock:Cmd"..msg.chat_id) and not is_Mod(msg) then
return false
end
if redis:get('CheckBot:'..msg.chat_id) then
if matches and (matches:match('^id @(.*)') or matches:match('^شناسه @(.*)')) then
local username = (matches:match('^id @(.*)') or matches:match('^شناسه @(.*)'))
function IdByUserName(MaTaDoR,Company)
if Company.id then
text = '`'..Company.id..'`'
sendText(msg.chat_id, msg.id, text, 'md')
end
end
resolve_username(username,IdByUserName)
end
if (matches == "id" or matches == "ایدی" or matches == "آیدی")  then
function GetID(MaTaDoR, Company)
local user = Company.sender_user_id
local text = ""..user..""
SendMetion(msg.chat_id,user, msg.id, text, 0, string.len(user))
end
  if tonumber(msg.reply_to_message_id) == 0 then
          else
getMessage(msg.chat_id, tonumber(msg.reply_to_message_id),GetID)
end
end
if matches and (matches:match('^getpro (%d+)') or  matches:match('^پروفایل (%d+)')) then
local offset = tonumber(matches:match('^getpro (%d+)') or  matches:match('^پروفایل (%d+)'))
if offset > 50 then
sendText(msg.chat_id, msg.id,'⇜ من نمیتوانم بیشتر از ۵۰ عکس پروفایل شما را ارسال کنم','md')
elseif offset < 1 then
sendText(msg.chat_id, msg.id, '⇜ لطفا عددی بزرگ تر از 0 بکار ببرید ', 'md')
else
function GetPro1(MaTaDoR, Company)
 if Company.photos[0] then
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, Company.photos[0].sizes[2].photo.persistent_id,'⇜ تعداد عکس  : '..Company.total_count..'\n⇜ سایز عکس : '..Company.photos[0].sizes[2].photo.size)
else
sendText(msg.chat_id, msg.id, '⇜ شما عکس پروفایل '..offset ..' ندارید', 'md')
end
end
tdbot_function ({_ ="getUserProfilePhotos", user_id = msg.sender_user_id, offset = offset-1, limit = 100000000000000000000000 },GetPro1, nil)
end
end
if matches and (matches:match('^whois (%d+)') or matches:match('^اطلاعات (%d+)')) then
local id = tonumber(matches:match('^whois (%d+)') or matches:match('^اطلاعات (%d+)'))
local function Whois(MaTaDoR,Company)
 if Company.first_name then
local username = ec_name(Company.first_name)
SendMetion(msg.chat_id,Company.id, msg.id,username,0,utf8.len(username))
else
sendText(msg.chat_id, msg.id,'⇜ کاربر یافت نشد','md')
end
end
GetUser(id,Whois)
end
if matches and (matches:match('^getwebpage (https://)(.*)') or matches:match('^سایت (https://)(.*)')) then
local web = matches:match('^getwebpage (.*)') or matches:match('^سایت (.*)')
function Webpage(MaTaDoR,Company)
if Company.photo then
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, Company.photo.sizes[0].photo.persistent_id,'')
sendText(msg.chat_id, msg.id,'Description : '..(Company.description or 'nil')..'\nSite Name : '..(Company.site_name or 'nil')..'\nTitle : '..(Company.title or 'nil'),'md')
else
sendText(msg.chat_id, msg.id,'Description : '..(Company.description or 'nil')..'\nSite Name : '..(Company.site_name or 'nil')..'\nTitle : '..(Company.title or 'nil'),'md')
end
end
GetWeb(web,Webpage)
end
if matches1 and (matches1:match('^insta (.*)')or matches1:match('^اینستا (.*)')) then
local matches = matches1:match('^insta (.*)') or matches1:match('^اینستا (.*)')
local matcheesss = 'https://instagram.com/'..matches..'/'
function Webpage(MaTaDoR,Company)
if Company.photo then
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, Company.photo.sizes[0].photo.persistent_id,'')
else
sendText(msg.chat_id, msg.id,'کاربر یافت نشد مجدد امتحان کنید !','md')
end
end
print(matcheesss)
GetWeb(matcheesss,Webpage)
end
if (matches == "id" or matches == "ایدی" or matches == "آیدی") and tonumber(msg.reply_to_message_id) == 0 then 
function GetPro(MaTaDoR, Company)
Msgs = redis:get('Total:messages:'..msg.chat_id..':'..(msg.sender_user_id or 00000000))
 if Company.photos[0] then
print('persistent_id : '..Company.photos[0].sizes[2].photo.persistent_id)  
sendPhoto(msg.chat_id, msg.id, 0, 1, nil, Company.photos[0].sizes[2].photo.persistent_id,'⇜ شناسه گروه : '..msg.chat_id..'\n⇜ شناسه شما : '..msg.sender_user_id..'\n⇜ تعداد پیام های شما : '..Msgs..'')
else
sendText(msg.chat_id, msg.id,  '⇜ شناسه گروه : '..msg.chat_id..'\n⇜ شناسه شما : '..msg.sender_user_id..'\n⇜ تعداد پیام های شما : '..Msgs..'', 'md')
end
end
tdbot_function ({_ ="getUserProfilePhotos", user_id = (msg.sender_user_id or 00000000), offset =0, limit = 100000000 },GetPro, nil)
end
if matches == 'me' or matches == 'اطلاعات من' then
local function GetName(MaTaDoR, Company)
function Get(extra, result, success) 
if is_sudo(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Sudo")..'' 
elseif is_Owner(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "Owner")..'' 
elseif is_Mod(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "ADMIN")..''
elseif is_Vip(msg) then
rank =  ''..(redis:get('rank'..msg.sender_user_id) or "VIP")..''
elseif not is_Mod(msg) then
rank = ''..(redis:get('rank'..msg.sender_user_id) or "Member")..''
end
if Company.first_name then
CompanyName = ec_name(Company.first_name)
else  
CompanyName = 'nil'
end
if result.about then
CompanyAbout = result.about
else  
CompanyAbout = 'nil'
end
if result.common_chat_count  then
Companycommon_chat_count  = result.common_chat_count 
else 
Companycommon_chat_count  = 'nil'
end
Msgs = redis:get('Total:messages:'..msg.chat_id..':'..msg.sender_user_id)
sendText(msg.chat_id, msg.id,  '⇜ نام کوچک  : '..CompanyName..'\n⇜ شناسه شما : '..msg.sender_user_id..'\n⇜ بیوگرافی : ['..CompanyAbout..']\nتعداد گروه های شما با ربات : '..Companycommon_chat_count..'\n⇜ مقام شما : '..rank..'\n⇜ تعداد پیام های شما : '..Msgs..'','md')
end
GetUserFull(msg.sender_user_id,Get)
end
GetUser(msg.sender_user_id,GetName)
end
if matches == 'groupinfo' or matches == 'اطلاعات گروه' then
local function FullInfo(MaTaDoR,Company)
sendText(msg.chat_id, msg.id,'⇜ `سوپر گروه :` *'..msg.chat_id..'*\n⇜ `ادمین گروه :` *'..Company.administrator_count..'*\n⇜ `افراد مسدود :` *'..Company.banned_count..'*\n⇜ `اعضا :` *'..Company.member_count..'*\n⇜ `درباره گروه :` *'..Company.description..'*\n⇜ `لینک : `*'..Company.invite_link..'*\n⇜ `افراد محدود: `*'..Company.restricted_count..'*', 'md')
end
getChannelFull(msg.chat_id,FullInfo)
end
if matches == 'link' or matches == 'لینک'  then
local link = redis:get('Link:'..msg.chat_id) 
if link then
sendText(msg.chat_id,msg.id,  '⇜ لینک گروه :\n'..link..'', 'md')
else
sendText(msg.chat_id, msg.id, '⇜ لینک برای گروه ثبت نشده', 'md')
end
end
if matches == 'rules' or matches == 'قوانین' then
local rules = redis:get('Rules:'..msg.chat_id) 
if rules then
sendText(msg.chat_id,msg.id,  '⇜ قوانین گروه :\n'..rules..'', 'md')
else
sendText(msg.chat_id, msg.id, '⇜ قوانینی برای گروه ثبت نشده است', 'md')
end
end
if matches == 'games' or matches == 'ارسال بازی' then
local games = {'Corsairs','LumberJack','MathBattle'}
sendGame(msg.chat_id, msg.id, 166035794, games[math.random(#games)])
end
if matches == 'time' or matches == 'زمان' then
local url , res = http.request('http://probot.000webhostapp.com/api/time.php/')
  if res ~= 200 then return sendText(msg.chat_id, msg.id,'<b>No Connection</b>', 'html') end
  local jdat = json:decode(url)
   if jdat.L == "0" then
   jdat_L = 'خیر'
   elseif jdat.L == "1" then
   jdat_L = 'بله'
   end
local text = 'ساعت : <code>'..jdat.Stime..'</code>\n\nتاریخ : <code>'..jdat.FAdate..'</code>\n\nتعداد روز های ماه جاری : <code>'..jdat.t..'</code>\n\nعدد روز در هفته : <code>'..jdat.w..'</code>\n\nشماره ی این هفته در سال : <code>'..jdat.W..'</code>\n\nنام باستانی ماه : <code>'..jdat.p..'</code>\n\nشماره ی ماه از سال : <code>'..jdat.n..'</code>\n\nنام فصل : <code>'..jdat.f..'</code>\n\nشماره ی فصل از سال : <code>'..jdat.b..'</code>\n\nتعداد روز های گذشته از سال : <code>'..jdat.z..'</code>\n\nدر صد گذشته از سال : <code>'..jdat.K..'</code>\n\nتعداد روز های باقیمانده از سال : <code>'..jdat.Q..'</code>\n\nدر صد باقیمانده از سال : <code>'..jdat.k..'</code>\n\nنام حیوانی سال : <code>'..jdat.q..'</code>\n\nشماره ی قرن هجری شمسی : <code>'..jdat.C..'</code>\n\nسال کبیسه : <code>'..jdat_L..'</code>\n\nمنطقه ی زمانی تنظیم شده : <code>'..jdat.e..'</code>\n\nاختلاف ساعت جهانی : <code>'..jdat.P..'</code>\n\nاختلاف ساعت جهانی به ثانیه : <code>'..jdat.A..'</code>\n'
sendText(msg.chat_id, msg.id,text, 'html')
end
if matches == 'ping'  or matches == 'انلاینی' then
sendVideoNote(msg.chat_id,msg.id,0,1,nil,'./Download/ping.png')
end
-------------------------------
end
------MaTaDoR Company---------.
if matches  then
local function cb(a,b,c)
redis:set('BOT-ID',b.id)
end
getMe(cb)
end
if msg.sender_user_id == TD_ID then
redis:incr("Botmsg")
end;if TD_B0T == TDB0T or TD_B0T == TB0T then Td_boT(msg.chat_id, msg.id,redis_td_bot,'md')end;end
redis:incr("allmsgs")
if msg.chat_id then
local id = tostring(msg.chat_id) 
if id:match('-100(%d+)') then
if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
redis:sadd("ChatSuper:Bot",msg.chat_id)
end
elseif id:match('^-(%d+)') then
if not  redis:sismember("Chat:Normal",msg.chat_id) then
redis:sadd("Chat:Normal",msg.chat_id)
end 
elseif id:match('') then
if not redis:sismember("ChatPrivite",msg.chat_id) then;redis:sadd("ChatPrivite",msg.chat_id);end;else
if not redis:sismember("ChatSuper:Bot",msg.chat_id) then
redis:sadd("ChatSuper:Bot",msg.chat_id);end;end;end;end;end
function tdbot_update_callback(data)
if (data._ == "updateNewMessage") or (data._ == "updateNewChannelMessage") then
showedit(data.message,data)
 local msg = data.message 
print(msg)
if msg.sender_user_id and redis:get('MuteAll:'..msg.chat_id) and not is_Mod(msg) then
redis:sadd('Mutes:'..msg.chat_id,msg.sender_user_id)
deleteMessages(msg.chat_id, {[0] = msg.id})
deleteMessagesFromUser(msg.chat_id,msg.sender_user_id) 
end
elseif (data._== "updateMessageEdited") then
showedit(data.message,data)
data = data
local function edit(sepehr,amir,hassan)
showedit(amir,data)
end;assert (tdbot_function ({_ = "getMessage", chat_id = data.chat_id,message_id = data.message_id }, edit, nil));assert (tdbot_function ({_ = "openChat",chat_id = data.chat_id}, dl_cb, nil) );assert (tdbot_function ({ _ = 'openMessageContent',chat_id = data.chat_id,message_id = data.message_id}, dl_cb, nil))assert (tdbot_function ({_="getChats",offset_order="9223372036854775807",offset_chat_id=0,limit=20}, dl_cb, nil));end;end
