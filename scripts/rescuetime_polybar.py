#!/usr/bin/env python3
# Inspiration taken from: https://gist.github.com/kenkeiter/f9e353f93dc0d7d8e935

import datetime
import requests
import json
import os
import sys
from pathlib import Path
from datetime import date, timedelta

url = "https://www.rescuetime.com/anapi/data"

rescuetime_key_path = Path.home() / ".rescuetime_key"
api_key = None

try:
    with open(rescuetime_key_path) as f:
        api_key = f.read().strip()
except FileNotFoundError:
    print("Error: {rescuetime_key_path}' must be set!")
    sys.exit(1)


def rows_to_json(response_body):
    entries = []
    for row in response_body["rows"]:
        entry = {}
        for idx, row_header in enumerate(response_body["row_headers"]):
            entry[row_header] = row[idx]
        entries.append(entry)
    return entries


def calculate_productivity(start_date, end_date):
    res = requests.get(
        url,
        params={
            "key": api_key,
            "perspective": "interval",
            "restrict_kind": "productivity",
            "resolution_time": "day",
            "restrict_begin": start_date,
            "restrict_end": end_date,
            "format": "json",
        },
    )
    res.raise_for_status()
    data = rows_to_json(res.json())
    productive_seconds = 0
    total_seconds = 0
    for entry in data:
        seconds = entry["Time Spent (seconds)"]
        total_seconds += seconds
        if entry["Productivity"] > 0:
            productive_seconds += seconds
    delta = timedelta(seconds=productive_seconds)
    return {
        "productive_time": delta,
        "productivity_pulse": int(round(productive_seconds / total_seconds * 100)),
    }


def format_hh_mm(timedelta_):
    h, rest = divmod(timedelta_.total_seconds(), 3600)
    min, _ = divmod(rest, 60)
    # format 4 to 04, so that 4:4 becomes 04:04
    f = lambda n: str(int(n)).zfill(2)
    h = f(h)
    min = f(min)
    return f"{h}:{min}"


def hours(seconds):
    return seconds / 60.0 / 60.0


def time_to_color(productivity_pulse):
    color = ""
    if productivity_pulse > 65:
        color = "#37a600"
    elif productivity_pulse > 55:
        color = "#33ffd4"
    elif productivity_pulse > 40:
        color = "#ff7733"
    else:
        color = "#C70039"
    return "%{F" + color + "}"


def time_to_symbol(productivity_pulse):
    if productivity_pulse > 65:
        return "›››"
    elif productivity_pulse > 55:
        return "››"
    elif productivity_pulse > 40:
        return "›"
    return ":("


today = datetime.date.today()
monday = today + datetime.timedelta(days=-today.weekday())

productivity_metrics_today = calculate_productivity(start_date=today, end_date=today)
productivity_metrics_week = calculate_productivity(start_date=monday, end_date=today)
productive_time_today = productivity_metrics_today["productive_time"]
productive_time_week = productivity_metrics_week["productive_time"]
productivity_pulse_today = productivity_metrics_today["productivity_pulse"]
time_today_formatted = format_hh_mm(productive_time_today)
time_week_formatted = format_hh_mm(productive_time_week)
symbol = time_to_symbol(productivity_pulse_today)
color = time_to_color(productivity_pulse_today)

text = f"{color}{symbol} {productivity_pulse_today}% @ {time_today_formatted} ({time_week_formatted})"
print(text)
