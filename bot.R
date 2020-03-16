library(telegram.bot)
source('bot_token.R') # bot token (hidden with .gitignore)

# saves bot token and updaters --------------------------------------------
bot <- Bot(token = bot_token("RLadiesSP"))
updater <- Updater(token = bot_token("RLadiesSP"))
updates <- bot$getUpdates()


# sends welcome message ---------------------------------------------------
welcome <- function(bot, update){
  if (length(update$message$new_chat_participant) > 0L) {
    bot$sendMessage(chat_id = update$message$chat_id,
                    text = paste0('Seja bem-vinda(o), ', update$message$new_chat_participant$first_name,
                                  ' (@', update$message$new_chat_participant$username,')!'))
  }
}

updater <- updater + MessageHandler(welcome, MessageFilters$all)


# creates command to kill bot ---------------------------------------------
kill <- function(bot, update){
  bot$sendMessage(chat_id = update$message$chat_id,
                  text = "Parando por aqui...")
  # Clean 'kill' update
  bot$getUpdates(offset = update$update_id + 1L)
  # Stop the updater polling
  updater$stop_polling()
}

updater <<- updater + CommandHandler("kill", kill,
                                     as.BaseFilter(function(message) message$from_user  == "15366329"))

# starts bot --------------------------------------------------------------
updater$start_polling()

# welcome command ---------------------------------------------------------
# welcome_message <- function(bot, update){
#   bot$sendMessage(chat_id = update$message$chat_id,
#                   text = paste0('"', update$message$text, '" saved as welcome message!'))
# }
# 
# updater <- updater + CommandHandler("welcome", welcome_message,
#                                     as.BaseFilter(function(message) message$from_user  == "15366329"))