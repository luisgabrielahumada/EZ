using Conditions.Services.Rules.Interface;
using Conditions.Services.Rules.Model;
using Gesi.Access.Database;
using Insight.Database;
using Ports.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Conditions.Services.Rules.Task
{
    public class ConditionServices : IConditionsTask
    {
        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IConditions>().DB_Condition_Delete(Token);
        }

        public IList<ConditionModel> Get(int PageIndex, int PageSize, out int TotalRecords)
        {
            return Database.CurrentCnn.As<IConditions>().DB_Condition_List(PageIndex, PageSize, out TotalRecords);
        }

        public ConditionModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<IConditions>().DB_Condition_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IConditions>().DB_Condition_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, string Name, float Value, string Description, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IConditions>().DB_Condition_Save(Token, Name, Value, Description, IsActive, UpdatedId);
        }

        public Tuple<IList<PortsModel>, IList<PortsModel>> GetConditionPortAssigned(Guid Token)
        {
            var results = Database.CurrentCnn.QueryResults<PortsModel, PortsModel>("DB_ConditionPort_Assigned", new { Token = Token });
            var byAssigned = results.Set1;
            var Assigned = results.Set2;
            return Tuple.Create(byAssigned, Assigned);
        }
    }
}