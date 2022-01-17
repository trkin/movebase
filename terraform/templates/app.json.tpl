[
  {
    "essential": true,
    "memory": 300,
    "name": "movebase-container",
    "cpu": 256,
    "image": "${REPOSITORY_URL}:${APP_VERSION}",
    "portMappings": [
        {
            "containerPort": 3000,
            "hostPort": 3000
        }
    ]
  }
]

