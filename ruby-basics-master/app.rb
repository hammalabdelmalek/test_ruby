require 'nokogiri'
require 'open-uri'
require 'json'


#class  representant un depute
class Deput 
   attr_reader :nom
   attr_reader :departement
   attr_reader :genre
   attr_reader :url
    def initialize(nom, departement,genre,url)
        @nom = nom
	@departement = departement
	@genre = genre
	@genre = url
    end
    def setnom(nom)
        @nom = nom
    end
    def setdep(departement)
        @departement = departement
    end
    def setgenre(genre)
        @genre = genre
    end
    def seturl(url)
    	@url = url
    end	
end


#function pour tester le genre du depute
def test(s)
   if s[1]==='m'
	return "Femme"
   else 
	return "Homme"
   end

end


#function qui retourn le nombre de depute femme stocker dans un fichier json
def nombre_femme 
       n = 0
       file = File.open("data2.json")
       file_data = file.read
       data_parsed = JSON.parse(file_data)
       data_parsed.each_with_index do |element, index|
	   if element["genre"] === "Femme"
		n = n+1
	   end
	end
	return "le nombre de femme parmis les deputes est de #{n}"
end


#function qui recherche parmi les depute et retourne les depute avec un nom qui contient une suite de caractere s
def cherche_parnom(s)
       result_array = []
       file = File.open("data2.json")
       file_data = file.read
       data_parsed = JSON.parse(file_data)
       data_parsed.each_with_index do |element, index|
	   if element["nom"] =~ /#{s}/
		result_array << element
	   end
	end
        return result_array
end


#function qui remplit et retourne un mail
def mail_construct(n,p,element,d,m)
return "Bonjour #{element["nom"]},

Je m’appelle #{p} #{n}, je réside dans #{d} et je me permet de vous contacter au sujet de mon autorisation pour construire une piscine dans mon jardin que j'ai deja envoyé, je voulais juste voire ou vous etes arrivez avec la demande vue que l'été est sur les portes.


Je vous adresse mes sincères salutations,

Bien cordialement,
#{p} #{n}


----------

Mail à adresser à #{m}"
end


#function qui recherche un depute dans votre departement et retourne un mail pour ce dernier
def par_departement(n,p,d)
       mail = ""
       file = File.open("data2.json")
       file_data = file.read
       data_parsed = JSON.parse(file_data)
       data_parsed.each_with_index do |element, index|
	   if element["departement"].upcase === d.upcase 
		html2 = URI.open(element["url"]).read
		nokogiri_doc2 = Nokogiri::HTML(html2)
		nokogiri_doc2.xpath("//a").each do |element|
		    if element.text =~ /@assemblee-nationale.fr/
			mail = element.text
		    end
		end
		return mail_construct(n,p,element,d,mail)
	   end
	end	

end


#function qui prend un url et fait du scraping de la page web qui contient les informations sur les deputes et les stocke dans un fichier json 
def scraping(url)

	depute = Deput.new("","","","")
	
	html = URI.open("#{url}").read
	nokogiri_doc = Nokogiri::HTML(html)
	depute_array = []
	i = 1
	nokogiri_doc.xpath("//td").each_with_index do |element,index|
	   if  i === 3 
	   	depute_array << depute
		depute = Deput.new("" ,"","","")
		i=1
	   elsif i === 2 
	        depute.setdep(element.text) 
		i = i+1
	   else
		l= element.css('a').map { |link| link['href'] }
		l.each do |e|
			depute.seturl(url[0,34]+e.strip)
		end
	        depute.setnom(element.text.strip)
		depute.setgenre(test(element.text.strip))
		i= i+1	
	   end
	end

	File.open("data2.json","w") do |f|
	 f.write( depute_array.map { |item| {:nom => item.nom, :departement => item.departement,:genre => item.genre,:url => item.url} }.to_json) 
	end 	
	
end

scraping("http://www2.assemblee-nationale.fr/deputes/liste/tableau")

puts "***************************************"

puts " le resultat de la recherche par nom : "
cherche_parnom("Hu").each_with_index do |element,index|
	puts "#{index+1} - #{element["nom"]} - #{element["departement"]}"
end

puts "***************************************"

puts nombre_femme 

puts "***************************************"

puts "Bonjour, donner votre nom"
nom = gets
puts "Donner votre prénom"
prenom = gets
puts "Dans quelle departement vous habitez"
departement = gets

puts "***************************************"
puts par_departement(prenom.strip,nom.strip,departement.strip)
puts "***************************************"


