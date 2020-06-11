class Planta {

	const anioDeObtencion
	const altura

	method horasDeSolToleradas()

	method esFuerte() {
		return self.horasDeSolToleradas() > 10
	}

	method daNuevaSemillas() { // Template method: Una condición general y otra particular
		return self.esFuerte() or self.condicionParaSemillas()
	}

	method condicionParaSemillas()

	method espacioQueOcupa()

	method esIdeal(parcela)

	method esAlta() {
		return altura > 1.5
	}

//	method seAsociaBien(parcela) {
//		// Código patovica: quién sos y veo qué hago -> Muere un polimorfismo
//		if (parcela.sosEcologica()) {
//			// me fijo la condición de ecológica
//		} else {
//			// me fijo la otra condición
//		}
//	}
}

class Menta inherits Planta {

	override method horasDeSolToleradas() {
		return 6
	}

//	override method daNuevaSemillas() { return super() or altura > 0.4 }
	override method condicionParaSemillas() {
		return altura > 0.4
	}

	override method espacioQueOcupa() {
		return altura * 3
	}

	override method esIdeal(parcela) {
		return parcela.superficie() > 6
	}

}

class HierbaBuena inherits Menta {

	override method espacioQueOcupa() {
		return super() * 2
	}

}

class Soja inherits Planta {

	override method horasDeSolToleradas() {
		if (altura < 0.5) {
			return 6
		} else if (altura > 0.5 and altura < 1) {
			return 7
		} else return 9
	}

	override method condicionParaSemillas() {
		return anioDeObtencion > 2007 and altura > 1
	}

	override method espacioQueOcupa() {
		return altura / 2
	}

	override method esIdeal(parcela) {
		return parcela.horasDeSol() == self.horasDeSolToleradas()
	}

}

class SojaTransgenica inherits Soja {

	override method daNuevaSemillas() {
		return false
	}

	override method esIdeal(parcela) {
		return parcela.maximoDePlantasToleradas() == 1
	}

}

class Quinoa inherits Planta {

	const property horasDeSolToleradas

//	override method horasDeSolToleradas() { return horasDeSol }  /// Se puede definir directamente con la property
	override method condicionParaSemillas() {
		return anioDeObtencion < 2005
	}

	override method espacioQueOcupa() {
		return 0.5
	}

	override method esIdeal(parcela) {
		return not parcela.tienePlantasAltas()
	}

}

const unaQuinoa = new Quinoa(horasDeSolToleradas = 10, anioDeObtencion = 2010, altura = 2)

class Parcela {

	const ancho
	const largo
	const property horasDeSol
	const plantas = []

	method superficie() {
		return ancho * largo
	}

	method maximoDePlantasToleradas() {
		if (ancho > largo) {
			return self.superficie() / 5
		} else {
			return self.superficie() / 3 + largo
		}
	}

	method tieneComplicaciones() {
		return plantas.any({ planta => planta.horasDeSolToleradas() < horasDeSol })
	}

	method plantar(planta) {
		self.validarNuevaPlanta(planta)
		plantas.add(planta)
	}

	method validarNuevaPlanta(planta) {
		if (plantas.size() + 1 > self.maximoDePlantasToleradas()) {
			self.error("No queda mas lugar")
		}
		if ((horasDeSol - planta.horasDeSolToleradas()) > 2) {
			self.error("La parcela recibe muchas horas de sol para esta planta")
		}
	}

	method tienePlantasAltas() {
		return plantas.any({ planta => planta.esAlta() })
	}

	method cantidadDePlantas() {
		return plantas.size()
	}

	method cantidadDePlantasBienAsociadas() {
		return plantas.count({ p => self.seAsociaBien(p) })
	}

	method porcentajeDePlantasBienAsociadas() {
		return self.cantidadDePlantasBienAsociadas() / self.cantidadDePlantas() * 100
	}
	
	method seAsociaBien(planta)

}

class ParcelaIndustrial inherits Parcela {

	override method seAsociaBien(planta) {
		return self.maximoDePlantasToleradas() == 2 and planta.esFuerte()
	}

}

class ParcelaEcologica inherits Parcela {

	override method seAsociaBien(planta) {
		return self.tieneComplicaciones() and planta.parcelaIdeal(self)
	}

}

object inta {

	const parcelas = []

	method promedioDePlantas() {
		return parcelas.sum({ parcela => parcela.cantidadDePlantas() }) / parcelas.size()
	}

	method masAutosustentable() {
		return parcelas
			.filter({ p => p.cantidadDePlantas() > 4 })
			.max({ p => p.porcentajeDePlantasBienAsociadas() })
	}

}

