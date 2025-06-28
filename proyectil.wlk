import ejemplo.*
import nivel.*
class Proyectil {

 var property danio
  var property image
  var property position
  var property nombre


  const velocidad = 60
			
			//Orientacion de la flecha:
				var property orientacion = 0
			
		//Metodo que remueve la flecha del tablero:
			method remover(){
				
				//Se le avisa al estado que la flecha fue disparada, por ende vuelve a su estado por defecto:
					//flecha_lanzada = false
					
				//Se remueve el visual junto con su avance constante:	
					game.removeVisual(self)
					game.removeTickEvent("avanzar")
					
				//La posición regresa a el jugador:
					self.position(personaje.position())
			}
        method iniciar(direccion, posicion){
				
				//Se añade la visual:
					game.addVisual(self)
				
				//La flecha empieza por la posición del jugador. De ahí, también se define la orientación a donde vaya:
					self.orientacion(direccion)
					self.position(posicion)
				
				game.onCollideDo(self, {visuales =>
							
							//Enemigos:
								if(visuales.nombre() == "enemigos"){
									
									//Recibe Daño:
										visuales.herir(self.danio())
										self.remover()
									
								}
							
							//Paredes
								if(visuales.nombre() == "pared"){
									
									//Choca y se rompe la flecha:
										self.remover()
										
								}
							
						})
				
			}
        method avanzar(){
				
				if (orientacion == personaje.derecha()){
					self.position(position.right(1))
				}
				
				if (orientacion == personaje.izquierda()){
					self.position(position.left(1))
				}
				
				if (orientacion == personaje.arriba()){
					self.position(position.up(1))
				}
				
				if (orientacion == personaje.abajo()){
					self.position(position.down(1))
				}
				
			}
        method lanzarBala(direccion, posicion){
				
				//Revisa el estado de la flecha:
					
						
						//Si la flecha fue lanzada, se inicia el comportamiento de la flecha en sí. Como parámetros la orientación del jugador junto con su posición como en el mismo método:
							self.iniciar(direccion, posicion)
							
						//Se ejecuta la acción avanzar constantemente, mientras que a la vez también se comprueba la posición de la flecha en conjunto.
							game.onTick(velocidad, "avanzar", { self.avanzar()})
							
						//Se le avisa al estado que la flecha fue lanzada:
											
					
					
			}
					

  }

class Bala inherits Proyectil(danio=25, image = "bala.png", velocidad=60) {

}