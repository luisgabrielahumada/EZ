using Gesi.Core.Web.Model;
using Newtonsoft.Json;
using Products.Services.Rules.Model;
using System.Collections.Generic;

namespace StowageFactors.Services.Rules.Model
{
    public class StowageFactorModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("description")]
        public float Description { get; set; }

        [JsonProperty("measure")]
        public string Measure { get; set; }

        [JsonProperty("value")]
        public float Value { get; set; }

        [JsonProperty("product")]
        public List<ProductModel> Product { get; set; }
    }
}