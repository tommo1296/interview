#!/bin/bash

sudo amazon-linux-extras install -y nginx1
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
