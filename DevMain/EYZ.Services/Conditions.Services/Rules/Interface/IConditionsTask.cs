using Conditions.Services.Rules.Model;
using Ports.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Conditions.Services.Rules.Interface
{
    public interface IConditionsTask
    {
        void Save(Guid Token, String Name, float Value, String Description, bool IsActive, int UpdatedId);

        IList<ConditionModel> Get(int PageIndex, int PageSize, out int TotalRecords);

        ConditionModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);

        Tuple<IList<PortsModel>, IList<PortsModel>> GetConditionPortAssigned(Guid Token);
    }
}