using Clauses.Services.Rules.Model;
using Gesi.Core.Web.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace Contract.Services.Rules.Model
{
    public class ContractModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("name")]
        public string Name { get; set; }

        [JsonProperty("code")]
        public string Code { get; set; }

        [JsonProperty("availableFrom")]
        public DateTime AvailableFrom { get; set; }

        [JsonProperty("observation")]
        public string Observation { get; set; }

        [JsonProperty("contractClauses")]
        public List<ClausesModel> ContractClauses { get; set; }
    }
}