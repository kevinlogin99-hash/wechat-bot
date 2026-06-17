从 flask 导入 Flask, request
从 db 导入 add_points, get_points

app = Flask(__name__)

# =========================
# 企业微信消息入口
# =========================
@app.route("/wechat", methods=["POST"])
def wechat():

    data = request.json

    # 用户ID（企业微信用户）
    user = data.get("FromUserName")

    # 事件类型（入群/退群/消息）
    event = data.get("Event")

    # 消息内容
    content = data.get("Content", "")

    # =====================
    # 1️⃣ 入群奖励
    # =====================
    if event == "join_chatroom":
        add_points(user, 5)
        return "入群 +5积分"

    # =====================
    # 2️⃣ 退群扣分
    # =====================
    if event == "quit_chatroom":
        add_points(user, -10)
        return "退群 -10积分"

    # =====================
    # 3️⃣ 文本消息处理
    # =====================
    if event == "message":

        # 签到
        如果 content == "签到":
            add_points(user, 5)
            return "签到成功 +5积分"

        # 查询积分
        如果 content == "积分":
            pts = get_points(user)
            return f"当前积分：{pts}"

        # 拉新
        if content.startswith("邀请"):
            add_points(user, 10)
            return "邀请成功 +10积分"

    return "ok"


# =========================
# 启动服务
# =========================
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
