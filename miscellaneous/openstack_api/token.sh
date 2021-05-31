#!/bin/bash
export OS_TOKEN=$(curl -i -s -H "Content-Type: application/json"   -d '
{ "auth": {
    "identity": {
      "methods": ["password"],
      "password": {
        "user": {
          "name": "usman",
          "domain": { "id": "default" },
          "password": "letmein"
        }
      }
    }
  }
}'   "http://10.82.1.100:5000/v3/auth/tokens" | grep -w "X-Subject-Token" | awk '{print $2}')