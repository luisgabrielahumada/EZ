using Gesi.Core.Web.Model;
using Newtonsoft.Json;
using Products.Services.Rules.Model;
using System.Collections.Generic;

namespace Quantity.Services.Rules.Model
{
    public class QuantityModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("quantity")]
        public float Quantity { get; set; }

        [JsonProperty("description")]
        public string Description { get; set; }

        [JsonProperty("measure")]
        public string Measure { get; set; }

        [JsonProperty("product")]
        public List<ProductModel> Product { get; set; }
    }
}