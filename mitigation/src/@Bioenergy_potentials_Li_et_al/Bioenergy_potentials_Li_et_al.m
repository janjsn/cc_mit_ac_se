classdef Bioenergy_potentials_Li_et_al
    %BIOENERGY_POTENTIAL_LI_ET_AL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        crop_allocation_pe_optimal
        
        pe_optimal
        pe_miscanthus
        pe_switchgrass
        pe_willow
        pe_poplar
        pe_eucalypt
        
        pe_optimal_tot
        pe_miscanthus_tot
        pe_switchgrass_tot
        pe_willow_tot
        pe_poplar_tot
        pe_eucalypt_tot
        
        pe_optimal_outside_bh_tot
        pe_miscanthus_outside_bh_tot
        pe_switchgrass_outside_bh_tot
        pe_willow_outside_bh_tot
        pe_poplar_outside_bh_tot
        pe_eucalypt_outside_bh_tot
        
        pe_yield_optimal
        pe_yield_miscanthus
        pe_yield_switchgrass
        pe_yield_willow
        pe_yield_poplar
        pe_yield_eucalypt
        
        mean_pe_yield_optimal
        mean_pe_yield_miscanthus
        mean_pe_yield_switchgrass
        mean_pe_yield_willow
        mean_pe_yield_poplar
        mean_pe_yield_eucalypt
        
        mean_pe_yield_productive_optimal
        mean_pe_yield_productive_miscanthus
        mean_pe_yield_productive_switchgrass
        mean_pe_yield_productive_willow
        mean_pe_yield_productive_poplar
        mean_pe_yield_productive_eucalypt
        
        mean_pe_yield_outside_bh_optimal
        mean_pe_yield_outside_bh_miscanthus
        mean_pe_yield_outside_bh_switchgrass
        mean_pe_yield_outside_bh_willow
        mean_pe_yield_outside_bh_poplar
        mean_pe_yield_outside_bh_eucalypt
        
        mean_pe_yield_outside_bh_productive_optimal
        mean_pe_yield_outside_bh_productive_miscanthus
        mean_pe_yield_outside_bh_productive_switchgrass
        mean_pe_yield_outside_bh_productive_willow
        mean_pe_yield_outside_bh_productive_poplar
        mean_pe_yield_outside_bh_productive_eucalypt
        
        
        
    end
    
    methods
        function obj = Bioenergy_potentials_Li_et_al(Bioenergy_yields_Li, land, land_outside_biodiversity_hotspots)
            obj.crop_allocation_pe_optimal = Bioenergy_yields_Li.energy_optimal_crop_allocation_5arcmin;
            
            obj.pe_optimal = land.*Bioenergy_yields_Li.pe_yields_energy_optimal_5arcmin;
            obj.pe_miscanthus = land.*Bioenergy_yields_Li.pe_yields_miscanthus_5arcmin;
            obj.pe_switchgrass = land.*Bioenergy_yields_Li.pe_yields_switchgrass_5arcmin;
            obj.pe_willow= land.*Bioenergy_yields_Li.pe_yields_willow_5arcmin;
            obj.pe_poplar= land.*Bioenergy_yields_Li.pe_yields_poplar_5arcmin;
            obj.pe_eucalypt= land.*Bioenergy_yields_Li.pe_yields_eucalypt_5arcmin;
            
            obj.pe_optimal_tot = sum(sum(obj.pe_optimal));
            obj.pe_miscanthus_tot = sum(sum(obj.pe_miscanthus));
            obj.pe_switchgrass_tot= sum(sum(obj.pe_switchgrass));
            obj.pe_willow_tot= sum(sum(obj.pe_willow));
            obj.pe_poplar_tot= sum(sum(obj.pe_poplar));
            obj.pe_eucalypt_tot= sum(sum(obj.pe_eucalypt));
            
            obj.pe_optimal_outside_bh_tot = sum(sum(land_outside_biodiversity_hotspots.*Bioenergy_yields_Li.pe_yields_energy_optimal_5arcmin));
            obj.pe_miscanthus_outside_bh_tot = sum(sum(land_outside_biodiversity_hotspots.*Bioenergy_yields_Li.pe_yields_miscanthus_5arcmin));
            obj.pe_switchgrass_outside_bh_tot = sum(sum(land_outside_biodiversity_hotspots.*Bioenergy_yields_Li.pe_yields_switchgrass_5arcmin));
            obj.pe_willow_outside_bh_tot = sum(sum(land_outside_biodiversity_hotspots.*Bioenergy_yields_Li.pe_yields_willow_5arcmin));
            obj.pe_poplar_outside_bh_tot = sum(sum(land_outside_biodiversity_hotspots.*Bioenergy_yields_Li.pe_yields_poplar_5arcmin));
            obj.pe_eucalypt_outside_bh_tot = sum(sum(land_outside_biodiversity_hotspots.*Bioenergy_yields_Li.pe_yields_eucalypt_5arcmin));
            
            total_land = sum(sum(land));
            total_land_bh = sum(sum(land_outside_biodiversity_hotspots));
            
            obj.pe_yield_optimal = obj.pe_optimal./land;
            obj.pe_yield_miscanthus = obj.pe_miscanthus./land;
            obj.pe_yield_switchgrass = obj.pe_switchgrass./land;
            obj.pe_yield_willow = obj.pe_willow./land;
            obj.pe_yield_poplar = obj.pe_poplar./land;
            obj.pe_yield_eucalypt = obj.pe_eucalypt./land;
            
            obj.pe_yield_optimal(isnan(obj.pe_yield_optimal)) = 0;
            obj.pe_yield_miscanthus(isnan(obj.pe_yield_miscanthus)) = 0;
            obj.pe_yield_switchgrass(isnan(obj.pe_yield_switchgrass)) = 0;
            obj.pe_yield_willow(isnan(obj.pe_yield_willow)) = 0;
            obj.pe_yield_poplar(isnan(obj.pe_yield_poplar)) = 0;
            obj.pe_yield_eucalypt(isnan(obj.pe_yield_eucalypt)) = 0;
            
            obj.mean_pe_yield_optimal= obj.pe_optimal_tot/total_land;
            obj.mean_pe_yield_miscanthus = obj.pe_miscanthus_tot/total_land;
            obj.mean_pe_yield_switchgrass = obj.pe_switchgrass_tot/total_land;
            obj.mean_pe_yield_willow = obj.pe_willow_tot/total_land;
            obj.mean_pe_yield_poplar = obj.pe_poplar_tot/total_land;
            obj.mean_pe_yield_eucalypt = obj.pe_eucalypt_tot/total_land;
            
            obj.mean_pe_yield_productive_optimal = obj.pe_optimal_tot/sum(sum(land(obj.pe_yield_optimal > 0)));
            obj.mean_pe_yield_productive_miscanthus = obj.pe_miscanthus_tot/sum(sum(land(obj.pe_yield_miscanthus > 0)));
            obj.mean_pe_yield_productive_switchgrass = obj.pe_switchgrass_tot/sum(sum(land(obj.pe_yield_switchgrass > 0)));
            obj.mean_pe_yield_productive_willow = obj.pe_willow_tot/sum(sum(land(obj.pe_yield_willow > 0)));
            obj.mean_pe_yield_productive_poplar = obj.pe_poplar_tot/sum(sum(land(obj.pe_yield_poplar > 0)));
            obj.mean_pe_yield_productive_eucalypt = obj.pe_eucalypt_tot/sum(sum(land(obj.pe_yield_eucalypt > 0)));
            
            obj.mean_pe_yield_outside_bh_optimal= obj.pe_optimal_tot/total_land_bh;
            obj.mean_pe_yield_outside_bh_miscanthus = obj.pe_miscanthus_tot/total_land_bh;
            obj.mean_pe_yield_outside_bh_switchgrass = obj.pe_switchgrass_tot/total_land_bh;
            obj.mean_pe_yield_outside_bh_willow = obj.pe_willow_tot/total_land_bh;
            obj.mean_pe_yield_outside_bh_poplar = obj.pe_poplar_tot/total_land_bh;
            obj.mean_pe_yield_outside_bh_eucalypt = obj.pe_eucalypt_tot/total_land_bh;
            
            obj.mean_pe_yield_outside_bh_productive_optimal= obj.pe_optimal_outside_bh_tot/sum(sum(land_outside_biodiversity_hotspots(obj.pe_yield_optimal > 0)));
            obj.mean_pe_yield_outside_bh_productive_miscanthus = obj.pe_miscanthus_outside_bh_tot/sum(sum(land_outside_biodiversity_hotspots(obj.pe_yield_miscanthus > 0)));
            obj.mean_pe_yield_outside_bh_productive_switchgrass = obj.pe_switchgrass_outside_bh_tot/sum(sum(land_outside_biodiversity_hotspots(obj.pe_yield_switchgrass > 0)));
            obj.mean_pe_yield_outside_bh_productive_willow= obj.pe_willow_outside_bh_tot/sum(sum(land_outside_biodiversity_hotspots(obj.pe_yield_willow > 0)));
            obj.mean_pe_yield_outside_bh_productive_poplar= obj.pe_poplar_outside_bh_tot/sum(sum(land_outside_biodiversity_hotspots(obj.pe_yield_poplar > 0)));
            obj.mean_pe_yield_outside_bh_productive_eucalypt= obj.pe_eucalypt_outside_bh_tot/sum(sum(land_outside_biodiversity_hotspots(obj.pe_yield_eucalypt > 0)));
            
            
        end
    end
    
end

