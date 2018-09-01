using Contract.Services.Rules.Interface;
using Contract.Services.Rules.Model;
using Gesi.Access.Database;
using Insight.Database;
using System;
using Newtonsoft;
using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Contract.Services.Rules.Task
{
    public class NegotiationServices : INegotiationTask
    {
        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<INegotiation>().DB_Negotiation_Delete(Token);
        }

        public IList<NegotiationModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? IsActive)
        {
            return Database.CurrentCnn.As<INegotiation>().DB_Negotiation_List(PageIndex, PageSize, out TotalRecords, IsActive);
        }

        public NegotiationModel Get(Guid Token)
        {
            var data = Database.CurrentCnn.As<INegotiation>().DB_Negotiation_Get(Token);
            var obj = JObject.Parse(data.DetailNegotiation);
            data.Clauses = JsonConvert.DeserializeObject<List<NegotiationClauseModel>>(obj["DetailNegotiation"].ToString());
            data.DetailNegotiation = string.Empty;
            return data;
        }

        public NegotiationModel History(Guid Token)
        {
            var data = Database.CurrentCnn.As<INegotiation>().DB_NegotiationHistory_Get(Token);
            var obj = JObject.Parse(data.DetailNegotiation);
            data.History = JsonConvert.DeserializeObject<List<NegotiationHistoryModel>>(obj["History"].ToString());
            data.DetailNegotiation = string.Empty;
            return data;
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<INegotiation>().DB_Negotiation_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Continue(Guid ServiceLiquidationToken, List<NegotiationClauseModel> Clauses, bool IsActive, int UpdatedId)
        {
            var NegotiationsOfRequestId = Database.CurrentCnn.As<INegotiation>().DB_Negotiation_Save(ServiceLiquidationToken, IsActive, UpdatedId);
            foreach (var clauses in Clauses)
            {
                Database.CurrentCnn.As<INegotiation>().DB_DetailNegotiation_Save(clauses.Id, NegotiationsOfRequestId, clauses.Observation, clauses.IsModify, IsActive, UpdatedId);
            }
        }
    }
}