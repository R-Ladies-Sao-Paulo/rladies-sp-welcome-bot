library(telegram.bot)
source('bot_token.R') # bot token (hidden with .gitignore)

# saves bot token and updaters --------------------------------------------
bot <- Bot(token = bot_token("RLadiesSP"))
updater <- Updater(token = bot_token("RLadiesSP"))
updates <- bot$getUpdates()


# defines welcome message -------------------------------------------------
welcome_text <- "*R-Ladies é uma organização que promove a diversidade de gênero na comunidade da linguagem R.* R-Ladies São Paulo integra a organização R-Ladies Global, em São Paulo.

Nosso principal objetivo é *promover a linguagem computacional estatística R compartilhando conhecimento, assim, qualquer pessoa com interesse na linguagem é bem-vinda*, independente do nível de conhecimento 🥰

Nosso **público-alvo são as minorias de gênero**, portanto, mulheres cis, mulheres trans, bem como pessoas não-binárias e queer.

Buscamos fazer deste espaço um lugar seguro de aprendizado, então, sinta-se livre para fazer perguntas e saiba que não toleramos nenhuma forma de assédio.

• *Já faz parte da nossa comunidade no Meetup?* Se não fizer, *entra aqui: https://bit.ly/RLadiesSP*.

• Saiba, também, que estamos *rodando um censo para traçar o perfil da nossa comunidade* e entender o que as nossas ladies esperam da gente. *Para responder, só clicar aqui: http://bit.ly/rladies_sp_censo2020.*

Obrigada! 💖"

# sends welcome message ---------------------------------------------------
welcome <- function(bot, update){
  welcome_message <- paste0('Seja bem-vinde, ', update$message$new_chat_participant$first_name,
                            ' (@', update$message$new_chat_participant$username,')! \n\n', welcome_text)
  
  if (length(update$message$new_chat_participant) > 0L) {
    bot$sendMessage(chat_id = update$message$chat_id, text = welcome_message,
                    disable_web_page_preview = T, parse_mode="Markdown")
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
#                   text = paste0('update$message$text, ' saved as welcome message!'))
# }
# 
# updater <- updater + CommandHandler("welcome", welcome_message,
#                                     as.BaseFilter(function(message) message$from_user  == "15366329"))