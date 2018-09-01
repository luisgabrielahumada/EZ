using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Ports.Services.Rules.Model
{
    public class PortsModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("address")]
        public string Address { get; set; }

        [JsonProperty("phone")]
        public string Phone { get; set; }

        [JsonProperty("city")]
        public int City { get; set; }

        [JsonProperty("countryId")]
        public int CountryId { get; set; }

        [JsonProperty("cityName")]
        public string CityName { get; set; }

        [JsonProperty("Ifo")]
        public float Ifo { get; set; }

        [JsonProperty("Mgo")]
        public float Mgo { get; set; }

        [JsonProperty("terms")]
        public string Terms { get; set; }

        [JsonProperty("draft")]
        public float Draft { get; set; }

        [JsonProperty("dwt")]
        public float Dwt { get; set; }
    }
}