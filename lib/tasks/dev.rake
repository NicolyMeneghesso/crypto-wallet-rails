namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do 
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop)}
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    else 
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    Coin.delete_all
    
    show_spinner("Cadastrando as Moedas...") do
      coins = [
        {  
          description: "Bitcoin",
          acronym: "BTC",
          url_image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
          mining_type: MiningType.find_by(acronym: 'PoW')
        },  
        {  
          description: "Ethereum",
          acronym: "ETC",
          url_image: "https://coin-images.coingecko.com/coins/images/279/large/ethereum.png?1696501628",
          mining_type: MiningType.all.sample
        },
        {  
          description: "Dash",
          acronym: "DASH",
          url_image: "https://coin-images.coingecko.com/coins/images/19/large/dash-logo.png?1696501423",
          mining_type: MiningType.all.sample
        },
        {  
          description: "Iota",
          acronym: "IOT",
          url_image: "https://newsbit.nl/app/uploads/2022/04/logo-iota-test.png",
          mining_type: MiningType.all.sample
        },
        {  
          description: "ZCash",
          acronym: "ZEC",
          url_image: "https://coin-images.coingecko.com/coins/images/486/large/circle-zcash-color.png?1696501740",
          mining_type: MiningType.all.sample  
        }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastrando tipos de mineração...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private
    def show_spinner(msg_start, msg_end = "Concluído!")
      spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
      spinner.auto_spin
      yield
      spinner.success("#{msg_end}")
    end
end
