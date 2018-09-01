using Gesi.Core.Web.Model;
using Newtonsoft.Json;

namespace Clauses.Services.Rules.Model
{
    public class ClausesModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("code")]
        public string Code { get; set; }

        [JsonProperty("isModify")]
        public bool IsModify { get; set; }

        [JsonProperty("isSelected")]
        public bool IsSelected { get; set; }
        
    }
}