from flask import Flask, render_template, request, redirect, url_for
from db import configure_db, db
from models import User

app = Flask(__name__)
configure_db(app)

@app.before_request
def create_tables():
    db.create_all()

@app.route("/", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        password = request.form["password"]

        new_user = User(name=name, email=email, password=password)
        db.session.add(new_user)
        db.session.commit()

        return redirect(url_for("success"))

    return render_template("index.html")

@app.route("/success")
def success():
    return render_template("success.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)