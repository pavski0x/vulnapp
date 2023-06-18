#!/bin/python3

from flask import Flask, render_template, request, redirect, url_for
from pymongo import MongoClient
from bson.objectid import ObjectId
import os

app = Flask(__name__)


client = MongoClient("mongodb://10.0.10.10:27017/") 


db = client["items_db"]
collection = db["items"]

@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        item = request.form.get('item')
        collection.insert_one({"item": item})
    items = [item for item in collection.find()]
    return render_template('home.html', items=items)

@app.route('/delete/<item_id>', methods=['POST'])
def delete(item_id):
    collection.delete_one({'_id': ObjectId(item_id)})
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=3000, debug=False)
