using Gesi.Core.Web.Model;
using Newtonsoft.Json;
using Products.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Vessel.Services.Rules.Model
{
    public class VesselModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("description")]
        public string Description { get; set; }

        [JsonProperty("phone")]
        public string Phone { get; set; }

        [JsonProperty("email")]
        public string Email { get; set; }

        [JsonProperty("contact")]
        public string Contact { get; set; }

        [JsonProperty("cityId")]
        public int CityId { get; set; }

        [JsonProperty("speed")]
        public int Speed { get; set; }

        [JsonProperty("typeId")]
        public int TypeId { get; set; }

        [JsonProperty("capacity")]
        public int Capacity { get; set; }

        [JsonProperty("demurrage")]
        public float Demurrage { get; set; }

        [JsonProperty("rateLoading")]
        public float RateLoading { get; set; }

        [JsonProperty("rateUnloading")]
        public float RateUnloading { get; set; }

        [JsonProperty("ifoConsumed")]
        public float IfoConsumed { get; set; }

        [JsonProperty("mgoConsumed")]
        public float MgoConsumed { get; set; }

        [JsonProperty("owner")]
        public int Owner { get; set; }

        [JsonProperty("nextOpeningOn")]
        public DateTime NextOpeningOn { get; set; }

        [JsonProperty("nextOpeningPort")]
        public DateTime NextOpeningPort { get; set; }

        [JsonProperty("portName")]
        public String PortName { get; set; }

        [JsonProperty("terminalName")]
        public String TerminalName { get; set; }

        [JsonProperty("city")]
        public String City { get; set; }

        [JsonProperty("ownerName")]
        public String OwnerName { get; set; }

        [JsonProperty("dwt")]
        public String DWT { get; set; }

        [JsonProperty("grt")]
        public String GRT { get; set; }

        [JsonProperty("cubitfeetcapacity")]
        public String Cubitfeetcapacity { get; set; }

        [JsonProperty("tankercapacity")]
        public String Tankercapacity { get; set; }

        [JsonProperty("loa")]
        public String LOA { get; set; }

        [JsonProperty("beam")]
        public String Beam { get; set; }

        [JsonProperty("draft")]
        public String Draft { get; set; }

        [JsonProperty("Year")]
        public String year { get; set; }

        [JsonProperty("yesno")]
        public String YesNo { get; set; }

        [JsonProperty("code")]
        public String Code { get; set; }

        [JsonProperty("countryId")]
        public int CountryId { get; set; }

        [JsonProperty("products")]
        public List<ProductModel> Products { get; set; }

        [JsonProperty("propertys")]
        public List<PropertyVesselModel> Property { get; set; }
    }
}