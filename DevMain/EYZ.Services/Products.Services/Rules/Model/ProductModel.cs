using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Products.Services.Rules.Model
{
    public class ProductModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("description")]
        public string Description { get; set; }

        [JsonProperty("typeId")]
        public int TypeId { get; set; }

        [JsonProperty("measure")]
        public string Measure { get; set; }

        [JsonProperty("measureQuantity")]
        public string MeasureQuantity { get; set; }

        [JsonProperty("typeName")]
        public string TypeName { get; set; }
    }
}