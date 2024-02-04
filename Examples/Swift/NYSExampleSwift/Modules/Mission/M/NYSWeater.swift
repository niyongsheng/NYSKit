//
//	NYSWeater.swift


import Foundation

struct NYSWeater : Codable {

	let aqi : NYSWeaterAqi?
    let city : String?
    let cityEn : String?
    let cityid : String?
    let country : String?
    let countryEn : String?
    let data : [NYSWeaterData]?
    let updateTime : String?
    
    enum CodingKeys: String, CodingKey {
        case aqi
        case city
        case cityEn
        case cityid
        case country
        case countryEn
        case data
        case updateTime = "update_time"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        aqi = try container.decodeIfPresent(NYSWeaterAqi.self, forKey: .aqi)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        cityEn = try container.decodeIfPresent(String.self, forKey: .cityEn)
        cityid = try container.decodeIfPresent(String.self, forKey: .cityid)
        country = try container.decodeIfPresent(String.self, forKey: .country)
        countryEn = try container.decodeIfPresent(String.self, forKey: .countryEn)
        data = try container.decodeIfPresent([NYSWeaterData].self, forKey: .data)
        updateTime = try container.decodeIfPresent(String.self, forKey: .updateTime)
    }
}
