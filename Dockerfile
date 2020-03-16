FROM virtualstaticvoid/heroku-docker-r:build
CMD ["/usr/bin/R", "--no-save", "-f /app/bot.R"]