import wollok.game.*
import mainExample.*
import proyectil.*
import nivel.*



object mapaLaberinto1 {
    // Usamos 1 para paredes, 0 para caminos
    var property estructura = [
        0, 0, 0, 0, 9, 0, 9, 1, 1, 1, 0, 0, 1, 1, 1, 2, 1,
        1, 0, 0, 0, 9, 4, 9, 1, 0, 0, 0, 9, 0, 0, 0, 0, 1,
        0, 0, 0, 2, 0, 0, 0, 1, 0, 0, 0, 6, 0, 0, 0, 0, 1,
        9, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 3, 0, 0, 0,
        5, 0, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0,
        5, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 2, 9, 0, 0,
        9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0, 1,
        0, 0, 0, 7, 0, 0, 0, 1, 0, 2, 0, 0, 0, 0, 0, 2, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 
    ] 

    var property ancho = 17
    var property alto = 9
}

// - Clases para los elementos del juego 
//cambiar imagen por imagen property y dejarla vacia
class obstaculo {
    var property position 
    var property image
    method width() = 64
    method height() = 64
    method nombre() = "obstaculo"
}

object personaje {
    var property position = game.at(1, 1)
    var property posicionAnterior = position
    var property energy=100

    //var property direccion= position
    method direccionTexto() {
    if (orientacion == arriba) return "norte"
    if (orientacion == abajo) return "sur"
    if (orientacion == izquierda) return "oeste"
    if (orientacion == derecha) return "este"
    return "nulo"
    }


    var property nombre='personaje'

    var property orientacion=0

   // method orientacion(nuevaOrientacion)=nuevaOrientacion

    var property arriba=1
    var property abajo=0
    var property izquierda=2
    var property derecha=3

    //method direccion()=orientacion

    method image() = "militar1.png"
    //method imageAtaque()="personajeAAtaque.png"
    method width() = 64
    method height() = 64
    method position()=position



    method esPared(pos) {
        if (pos.x() < 0 or pos.x() >= mapping.mapa_actual().ancho() or
            pos.y() < 0 or pos.y() >= mapping.mapa_actual().alto()) {
            return true
        }
        var indice = pos.y() * mapping.mapa_actual().ancho() + pos.x()
        return mapping.mapa_actual().estructura().get(indice) == 1
    }
     method movete(posNueva) {
        var area=[]
        area = game.getObjectsIn(posNueva).filter({ obj => obj.nombre() == "obstaculo" })
        if (area.size() == 0) {
            position = posNueva
        }
    }


    method perderVida(){
    energy-=20
    if(energy<=0){
      game.stop()
    }
  }
  method ganarVida(valor){
    energy+=valor

  }

  method ataque(){
    new Proyectil(danio=70,image= "balaP-"+ self.direccionTexto() +".png",position=position,nombre='enemigos').lanzarBala(orientacion,position)

  }

  
  /*method ataque(){
    new Proyectil(danio=70,image= "balaP-"+direccion.toString()+".png",position=position,nombre='enemigos').lanzarBala(orientacion,position)

  }*/
}
class Enemigo{
	var property image = "enemigo.png"
    var property energy= 70
	var property position = game.at(9, 4) 
    var property posicionAnterior = position
    var property nombre="enemigos"
    method energy()=energy

    method position()=position

    method nombre()=nombre

    method aparecer(){
        position= nivel.posicionAleatoria()
        game.say(self,'aparezco')
        game.addVisual(self)
        self.perseguirPersonaje()

    }

    method perseguirPersonaje(){
        game.onTick(1000,"pesigo personaje",{self.acercarseA_(personaje)})
    }

    method pelearPersonaje(){
    personaje.perderVida()
    game.say(personaje,"me quedan"+personaje.energy()+"vidas restantes")

  }

  method herir(danio){

    energy-=danio

    self.muerte()
    
  }

  method muerte(){
    if(energy==0){
        self.morir()
    }
  }

  method morir(){
    game.removeVisual(self)
  }

	
	method acercarseA_(personaje) {
    //var posPersonaje = personaje.position()
    const jugadorX = personaje.position().x()
	const jugadorY =personaje.position().y()
			
				
        if (jugadorX < position.x()) {

            var posicionNueva = position.left(1)
            if (!self.esPared(posicionNueva)) {
                self.movete(posicionNueva)
            }

        } else if (jugadorX > position.x()) {

            var posicionNueva= position.right(1)
            if (!self.esPared(posicionNueva)) {
                self.movete(posicionNueva)

            }
        }

        if (jugadorY < position.y()) {

            var posicionNueva = position.down(1)
            if ( !self.esPared(posicionNueva)) {
                self.movete(posicionNueva)
            }
        } else if (jugadorY > position.y()) {

            var posicionNueva = position.up(1)
            if (!self.esPared(posicionNueva)) {
                self.movete(posicionNueva)
            }
        }
    }

    method esPared(pos) {
        if (pos.x() < 0 or pos.x() >= mapping.mapa_actual().ancho() or
            pos.y() < 0 or pos.y() >= mapping.mapa_actual().alto()) {
            return true
        }
        var indice = pos.y() * mapping.mapa_actual().ancho() + pos.x()
        return mapping.mapa_actual().estructura().get(indice) == 1
    }
     method movete(posNueva) {
        var area=[]
        area = game.getObjectsIn(posNueva).filter({ obj => obj.nombre() == "obstaculo" })
        if (area.size() == 0) {
            position = posNueva
        }
    }
}

// Objeto Mapping para manejar el dibujo del mapa 
object mapping {
    var property mapa_actual = mapaLaberinto1 
    
    // Método para limpiar todos los visuales del juego
    method limpiar() {
        game.allVisuals().forEach { visual => game.removeVisual(visual) }
    }


    //pruebo el siguiente
    method dibujar() {
        var x = 0
        var y = mapa_actual.alto() - 1

        mapa_actual.estructura().forEach { tipoElemento =>
            // Dibujar según el tipo de elemento
            if (tipoElemento == 1) {
                const pared = new obstaculo (position = game.at(x, y) , image = "arbol.png")
                game.addVisual(pared)
            } else if (tipoElemento == 2) {           //agregue el numero 2 y le pase la imagen como condicion
            const auto = new obstaculo(position = game.at(x, y), image = "autoGrande.png")
            game.addVisual(auto)
            } else if (tipoElemento == 3) {
                const autogris = new obstaculo (position = game.at(x,y), image = "autoGris.png")
                game.addVisual(autogris)
            } else if (tipoElemento == 4 ){
                const estacion = new obstaculo(position = game.at(x,y), image = "estacion-1.png.png" )
                game.addVisual(estacion)
            }
             else if (tipoElemento == 5 ){
                const container = new obstaculo(position = game.at(x,y), image = "container.png" )
                game.addVisual(container)
            } else if (tipoElemento == 6 ){
                const container_verde = new obstaculo(position = game.at(x,y), image = "container_verde.png" )
                game.addVisual(container_verde)
            } else if (tipoElemento == 7 ){
                const tronco = new obstaculo(position = game.at(x,y), image = "tronco.png" )
                game.addVisual(tronco)
            }  else if (tipoElemento == 9 ){
                const transparente = new obstaculo(position = game.at(x,y), image = "transparente.png" )
                game.addVisual(transparente)
            } 


            x += 1
            if (x == mapa_actual.ancho()) {
                x = 0
                y -= 1
            }
        }
    }
}

class Corazon{

  var property position=null

  var property image="corazn.png"
  method nombre()="corazon"

  const valor= 20
  method aparecer(){
    position= nivel.posicionAleatoria()
    game.addVisual(self)
  }

  method darVida(){
    personaje.ganarVida(valor)
    game.say(personaje,personaje.energy().toString())
    game.removeVisual(self)

  }



}

class Equipable{
    var property image
    
    var property dano

    var property position
}