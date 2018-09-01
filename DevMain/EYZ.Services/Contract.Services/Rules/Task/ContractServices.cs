using Clauses.Services.Rules.Model;
using Contract.Services.Rules.Interface;
using Contract.Services.Rules.Model;
using Gesi.Access.Database;
using Insight.Database;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Contract.Services.Rules.Task
{
    public class ContractServices : IContractTask
    {
        public void Delete(Guid Token, int UpdatedId)
        {
            Database.CurrentCnn.As<IContract>().DB_Contract_Delete(Token);
        }

        public IList<ContractModel> Get(int PageIndex, int PageSize, out int TotalRecords, int? IsActive)
        {
            return Database.CurrentCnn.As<IContract>().DB_Contract_List(PageIndex, PageSize, out TotalRecords, IsActive);
        }

        public ContractModel Get(Guid Token)
        {
            return Database.CurrentCnn.As<IContract>().DB_Contract_Get(Token);
        }

        public void Remove(Guid Token, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IContract>().DB_Contract_StatusUpdate(Token, IsActive, UpdatedId);
        }

        public void Save(Guid Token, string Name, string Code, string Observation, DateTime AvailableFrom, List<ClausesModel> ContractClauses, bool IsActive, int UpdatedId)
        {
            Database.CurrentCnn.As<IContract>().DB_Contract_Save(Token, Name, Code, Observation, AvailableFrom, string.Join("|", ContractClauses
                                                                                                                                          .Where(m => m.IsSelected)
                                                                                                                                          .Select(item => $"{item.Id}").ToArray()), IsActive, UpdatedId);
        }
    }
}