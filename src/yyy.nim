# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import httpClient
import json
import system
import times
import asyncdispatch
import os

proc getData(fd: AsyncFD) : bool =
  echo now(), " downloading data"
  let client = newHttpClient()
  let content = client.getContent("https://www.vdl.lu/fr/parking/data.json")

  let jsonNode = parseJson(content)

  let parking = getOrDefault(jsonNode, "parking")

  var f = open("parking.csv",  FileMode.fmAppend)

  for item in parking.items():
    f.writeLine(now(), ",", item{"id"}, ",", item{"title"}, ",", item{"actuel"})

  f.close()

  return false

proc ctrlc() {.noconv.} =
  echo "Ctrl+C pressed. Exiting..."
  quit()

when isMainModule:
  addTimer(1000*60*15, false, getData)
  setControlCHook(ctrlc)
  var nilFd: AsyncFD
  discard getData(nilFd)
  while true:
    sleep(60 * 1000)



