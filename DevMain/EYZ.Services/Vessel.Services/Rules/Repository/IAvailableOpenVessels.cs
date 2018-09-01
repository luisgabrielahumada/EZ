using System;

namespace Vessel.Services.Rules.Interface
{
    public partial interface IAvailableOpenVessels
    {
        dynamic DB_AvailableOpenVessels_Get(Guid Token);

        void DB_AvailableOpenVessels_Delete(Guid Token);

        void DB_AvailableOpenVessels_Save(Guid Token, DateTime NextOpeningOn, DateTime NextOpeningPort, int CurrentPortId, int CurrentTerminalId, int UpdatedId);
    }
}