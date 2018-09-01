using Products.Services.Rules.Model;
using StowageFactors.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace StowageFactors.Services.Rules.Interface
{
    public partial interface IStowageFactors
    {
        IList<StowageFactorModel> DB_StowageFactor_List(int PageIndex, int PageSize, int? ProductId, out int TotalRecords);

        StowageFactorModel DB_StowageFactor_Get(Guid Token);

        void DB_StowageFactor_Delete(Guid Token);

        void DB_StowageFactor_Save(Guid Token, String Name, float Value, bool IsActive, int UpdatedId, string Products);

        void DB_StowageFactor_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}