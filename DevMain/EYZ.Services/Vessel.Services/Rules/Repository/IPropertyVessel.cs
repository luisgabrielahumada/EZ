using Vessel.Services.Rules.Model;
using System;
using System.Collections.Generic;

namespace Vessel.Services.Rules.Interface
{
    public partial interface IPropertyVessel
    {
        IList<PropertyVesselModel> DB_PropertyVessel_List(int PageIndex, int PageSize, out int TotalRecords);

        PropertyVesselModel DB_PropertyVessel_Get(Guid Token);

        void DB_PropertyVessel_Delete(Guid Token);

        void DB_PropertyVessel_Save(Guid Token, String Name, String Code, bool IsActive, int UpdatedId);

        IList<PropertyVesselModel> DB_PropertyToVessel_List(Guid? Token, int UpdatedId, int Owner);

        void DB_PropertyVessel_StatusUpdate(Guid Token, bool IsActive, int UpdatedId);
    }
}