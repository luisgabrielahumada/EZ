using Gesi.Core.Web.Model;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;

namespace Contract.Services.Rules.Model
{
    public class NegotiationModel : BaseModel
    {
        [JsonProperty("id")]
        public int Id { get; set; }

        [JsonProperty("detailNegotiation")]
        public string DetailNegotiation { get; set; }

        [JsonProperty("clauses")]
        public List<NegotiationClauseModel> Clauses { get; set; }

        [JsonProperty("history")]
        public List<NegotiationHistoryModel> History { get; set; }

        [JsonProperty("serviceLiquidationToken")]
        public Guid ServiceLiquidationToken { get; set; }

        [JsonProperty("status")]
        public string Status { get; set; }
    }
}