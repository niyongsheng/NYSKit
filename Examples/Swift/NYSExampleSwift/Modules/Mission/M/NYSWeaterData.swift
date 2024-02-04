//
//	NYSWeaterData.swift


import Foundation

struct NYSWeaterData : Codable {

	let air : String?
	let airLevel : String?
	let air_tips : String?
	let alarm : NYSWeaterAlarm?
	let date : String?
	let day : String?
	let hours : [NYSWeaterHour]?
	let humidity : String?
	let index : [NYSWeaterIndex]?
	let pressure : String?
	let sunrise : String?
	let sunset : String?
	let tem : String?
	let tem1 : String?
	let tem2 : String?
	let uvDescription : String?
	let uvIndex : String?
	let visibility : String?
	let wea : String?
	let weaDay : String?
	let weaDayImg : String?
	let wea_img : String?
	let weaNight : String?
	let weaNightImg : String?
	let week : String?
	let win : [String]?
	let winMeter : String?
	let winSpeed : String?

}
