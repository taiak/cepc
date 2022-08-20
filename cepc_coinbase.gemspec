Gem::Specification.new do |s|
    s.name        = "cepc_coinbase"
    s.version     = "0.9.6"
    s.summary     = "CEP Calculator which use CEP class to fetch and process coin prices to print as formated string."
    s.description = "CepC is a mining estimation and coin ratio calculator and demonstrator. CepC basicly calculation and print class for mining rigs. Not to be confused with the demon-strator."
    s.authors     = ["tayak"]
    s.email       = "yasir.kiroglu@gmail.com"
    s.files       = ["lib/cepc_coinbase.rb"]
    s.homepage    = "https://github.com/taiak/cepc"
    s.license     = "Apache-2.0"
    s.add_runtime_dependency 'cep_coinbase', '~> 0.1.1'
  end