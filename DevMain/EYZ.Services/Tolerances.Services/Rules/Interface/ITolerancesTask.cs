using Tolerances.Services.Rules.Model;
using System;
using System.Collections.Generic;
using System.Text;

namespace Tolerances.Services.Rules.Interface
{
    public interface ITolerancesTask
    {
        void Save(Guid Token, String Name, int Value, bool IsActive, int UpdatedId);

        IList<ToleranceModel> Get(int PageIndex, int PageSize, out int TotalRecords);

        ToleranceModel Get(Guid Token);

        void Delete(Guid Token, int UpdatedId);

        void Remove(Guid Token, bool IsActive, int UpdatedId);
    }
}