class Personaje {
  const property fuerza
  const inteligencia
  var rol

  method cambiarRol(unRol) {
    rol = unRol
  }

  method potencialOfensivo() {
    return fuerza * 10 + rol.extra() 
  }

  method esInteligente()
  method esGroso() = self.esInteligente() || rol.esGroso(self)
}

object rolGuerrero {

  method extra() = 100

  method brutalidadInnata(unValor) {
    return 0
  }

  method esGroso(unPersonaje) {
    return unPersonaje.fuerza() > 50
  }
}

class rolCazador {
  var mascota = new Mascota(fuerza = 0, edad = 0, tieneGarras = false)

  method cambiarMascota(unaMascota) {
    mascota = unaMascota
  }

  method naceNuevaMascota(fuerza, edad, tieneGarras) {
    mascota = new Mascota(fuerza = fuerza, edad = edad, tieneGarras = tieneGarras)
  }

  method extra() = mascota.potencial()

  method brutalidadInnata(unValor) {
    return 0
  }

  method  esGroso(unPersonaje) {
    return mascota.esLongeva()
  }
}

class Mascota {
  var fuerza
  var edad
  var tieneGarras

  method initialize() {
    if (fuerza > 100) {
      self.error("la mascota no puede tener fuerza más que 100")
    }
  }

  method potencial() {
    if (tieneGarras) {
      return fuerza * 2
    } else {
      return fuerza
    }
  }

  method esLongeva() = edad > 10
}


object rolBrujo {

  method extra() = 0

  method brutalidadInnata(unValor) {
    return 0
  }

  method esGroso(unPersonaje) = true
}

class Orco inherits Personaje {
  override method potencialOfensivo() {
    return super() + rol.brutalidadInnata(super())
  }

  override method esInteligente() = false
}

class Humano inherits Personaje {
  override method esInteligente() = inteligencia > 50
}

class Localidad {
  var ejercito = new Ejercito()

  method enlistar(unPersonaje) {
    ejercito.agregar(unPersonaje)
  }

  method poderDefensivo() {
    return ejercito.potencial()
  }

  method serOcupada(unEjercito)
}

class Aldea inherits Localidad {
  const cantMaxima

  override method enlistar(unPersonaje) {
    if(ejercito.personajes().size() >= cantMaxima) {
      self.error("Se alcanzo el limite maximo")
    }
    super(unPersonaje)
  }

  override method serOcupada(unEjercito) {
    ejercito.clear()
    unEjercito.personajes().forEach({p => self.enlistar(p)})
    unEjercito.quitarLosMasFuertes(cantMaxima.min(10))
  }
}

class Ciudad inherits Localidad {
  method poderDefensivo() {
    return super() + 300
  }

  override method serOcupada(unEjercito) {
    ejercito = unEjercito
  }
}

class Ejercito {
  const property personajes = #{}

  method potencial() = personajes.sum({p => p.potencialOfensivo()})

  method agregar(unPersonaje) {personajes.add(unPersonaje)}

  method invadir(unaLocalidad) {
    if(self.puedeInvadir(unaLocalidad)) {
      unaLocalidad.serOcupada(self)
    }
  }

  method puedeInvadir(unaLocalidad) {
    return self.potencial() > unaLocalidad.poderDefensivo()  
  } 

  method los10MasPoderosos() = self.listaOrdenadaPorPoder().take(10)
  method listaOrdenadaPorPoder() {
    return personajes.asList().sortBy({p1, p2 => p1.potencialOfensivo() > p2.potencialOfensivo()})
  }

  method quitarLosMasFuertes(cantidadAQuitar) {
    personajes.removeAll(self.los10MasPoderosos().take(cantidadAQuitar))
  }
}