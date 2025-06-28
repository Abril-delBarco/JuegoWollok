import wollok.game.*
import ejemplo.*
import mainExample.*
import proyectil.*
object nivel{
    method iniciar(){
         mapping.dibujar()

    game.addVisual(personaje)

    self.generarEnemigos()

    self.generarVida()


    game.onCollideDo(personaje,{x=>x.pelearPersonaje()})

    game.onCollideDo(personaje,{x=>x.darVida()})

    game.schedule(20000,{game.removeTickEvent("aparece enemigo")})

    game.onTick(3000,"DISPARO",{x=>x.viajar()})

    keyboard.w().onPressDo({ personaje.movete(personaje.position().up(1)); personaje.orientacion(1) })
    keyboard.s().onPressDo({ personaje.movete(personaje.position().down(1));personaje.orientacion(0)})
    keyboard.a().onPressDo({ personaje.movete(personaje.position().left(1));personaje.orientacion(2) })
    keyboard.d().onPressDo({ personaje.movete(personaje.position().right(1));personaje.orientacion(3) })
    keyboard.space().onPressDo({personaje.ataque()})


   // game.onTick(1.randomUpTo(5) * 300, "movimiento", {
	//		enemigo.acercarseA_(personaje)
	//	})

    }
    method generarEnemigos(){
        game.onTick(2000,"aparece enemigo",{new Enemigo().aparecer()})
    }

    method posicionAleatoria()=game.at(0.randomUpTo(mapaLaberinto1.ancho()-2),0.randomUpTo(mapaLaberinto1.alto()-2))

    method generarVida(){
    game.onTick(5000,"aparece corazon",{new Corazon().aparecer()})
  }
}