#NB : bundle install 
require 'json'
data = JSON.parse(File.read('data.json'))

## Le fichier Data contient un tableau de hashs d'utilisateurs


########################
# Exercice
########################

# Afficher la troisième utilisateur

# Afficher le hash de l'utilisateur dont le prénom est "Codie"

# Afficher l'age de l'utilisateur dont le prénom est Andromache


# Afficher les informations suivantes pour le première utilisateur dont le nom de famille commence par un "M" : 

########################
# Profil utilisateur: 
# Prénom : <Prénom>
# Nom: <Nom>
# Age : <Age>
# Genre : <Gender>
########################


# Créer un nouvel utilisateur (hash) avec les caractéristiques des utilisateurs en base (first_name, last_name, age, gender)