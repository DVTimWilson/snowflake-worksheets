WITH dedupe_nresults AS (
    -- x7 rows for each NRESULT_KEY (flight) due to cabins and other specifics. We just want 1 row.
    SELECT *
    FROM manpower_cube.`04_curated`.fact_cbase_flight
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY NRESULT_KEY
        ORDER BY Last_refresh DESC
    ) = 1
),

base_flights AS (
    SELECT 
        *
        , CUNIT AS CUNIT_ALLOCATED 
          -- Calculate standard values
        , PRODUCTION_0300 * (PRODUCTION_PFD_PCT + 1) / 60
            AS CBASE_STANDARD_HOURS_PRODUCTION
        , DISHWASH_0100 * (DISHWASH_PFD_PCT + 1) / 60
            AS CBASE_STANDARD_HOURS_DISHWASH
        , TRANSPORT_0500 * (TRANSPORT_PFD_PCT + 1) / 60
            AS CBASE_STANDARD_HOURS_DELIVERY
        , ASSEMBLY_0200 * (ASSEMBLY_PFD_PCT + 1) / 60
            AS CBASE_STANDARD_HOURS_ASSEMBLY
    FROM dedupe_nresults
    WHERE CAIRLINE IS NOT NULL
        AND CAST(NFLIGHT_STATUS AS BIGINT) != 1
),

sjc_base AS (
    SELECT *
    FROM base_flights
    WHERE CUNIT = '1393'
),

non_sjc AS (
    SELECT *
    FROM base_flights
    WHERE CUNIT <> '1393'
    OR CUNIT IS NULL
),

/* ---------- MODIFIED SJC ROWS ---------- */
sjc_redistributed AS (
    SELECT
          a.NRESULT_KEY
        , a.NAIRLINE_KEY
        , a.DDEPARTURE
        , a.NRESULT_KEY_GROUP
        , a.NTRANSACTION
        , a.CUNIT       
        , a.CAIRLINE
        , a.NFLIGHT_NUMBER
        , a.CDEPARTURE_TIME
        , a.CRAMP_TIME
        , a.CKITCHEN_TIME
        , a.CACTYPE
        , a.CGALLEYVERSION
        , a.CCONFIGURATION
        , a.NLEG_NUMBER
        , a.CTLC_FROM
        , a.CTLC_TO
        , a.CARRIVAL_TIME
        , a.NDEPT_OFFSET
        , a.CHANDLING_TYPE
        , a.CHANDLING_DESC
        , a.CROUTING
        , a.COPCODE
        , a.CBOX_FROM
        , a.CBOX_TO
        , a.NFLIGHT_STATUS
        , a.CACCOUNT
        , a.CINFORMATION1
        , a.CINFORMATION2
        , a.NCOUNT_FLIGHT
        , a.CINPUT_SOURCE
        , a.NFREEZE
        , a.NHAS_AC_CHANGE
        , a.NFULL_CART_COUNT
        , a.NHALF_CART_COUNT
        , a.NCARRIER_COUNT
        , a.NOVEN_COUNT
        , a.NFREE_LOAD_COUNT
        , a.NGEN_COUNT
        , a.NCALC_COUNT
        , a.NEXPLOSION_COUNT
        , a.NDISTRIBUTION_COUNT
        , a.NFREEZE_COUNT
        , a.NDOCUMENTS_COUNT
        , a.NCLOSE_COUNT
        , a.NCAT_GROUP_KEY
        , a.NCAT_KEY
        , a.NEXT_CAT_KEY
        , a.DDEPARTURE_TIME_LOC
        , a.DISHWASH_0100
        , a.ASSEMBLY_0200
        , a.PRODUCTION_0300
        , a.PRODUCTION_FIXED
        , a.PRODUCTION_MULT
        , a.TRANSPORT_0500
        , a.FLIGHT_TOTAL
        , a.DISHWASH_PFD_PCT
        , a.ASSEMBLY_PFD_PCT
        , a.PRODUCTION_PFD_PCT
        , a.TRANSPORT_PFD_PCT
        , a.CCLASS
        , a.NBOOKING_CLASS
        , a.NVERSION
        , a.NPAX
        , a.NPAX_MEALS
        , a.NPAX_SPML
        , a.CLOS_GRP_CODE
        , a.CLOS_VAR
        , a.CLOS
        , a.Last_refresh

        , '1393' AS CUNIT_ALLOCATED
        , CASE WHEN b.Department = 'Food'
             THEN a.CBASE_STANDARD_HOURS_PRODUCTION
                  * CAST(REPLACE(b.SJC, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
          END AS CBASE_STANDARD_HOURS_PRODUCTION,

        CASE WHEN b.Department = 'E&S'
             THEN a.CBASE_STANDARD_HOURS_DISHWASH
                  * CAST(REPLACE(b.SJC, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_DISHWASH,

        CASE WHEN b.Department = 'Delivery'
             THEN a.CBASE_STANDARD_HOURS_DELIVERY
                  * CAST(REPLACE(b.SJC, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_DELIVERY,

        CASE WHEN b.Department = 'Assembly'
             THEN a.CBASE_STANDARD_HOURS_ASSEMBLY
                  * CAST(REPLACE(b.SJC, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_ASSEMBLY

    FROM sjc_base AS a
    LEFT JOIN manpower_cube.`04_curated`.master_standard_hours_distribution AS b
        ON TRUNC(DDEPARTURE, 'MM') = b.Date
        AND a.CAIRLINE   = b.CbaseID
        AND b.ProfitCenterName LIKE '%1393%'
),

/* ---------- SFO ROWS ---------- */
sfo_rows AS (
    SELECT
          a.NRESULT_KEY
        , a.NAIRLINE_KEY
        , a.DDEPARTURE
        , a.NRESULT_KEY_GROUP
        , a.NTRANSACTION
        , a.CUNIT    
        , a.CAIRLINE
        , a.NFLIGHT_NUMBER
        , a.CDEPARTURE_TIME
        , a.CRAMP_TIME
        , a.CKITCHEN_TIME
        , a.CACTYPE
        , a.CGALLEYVERSION
        , a.CCONFIGURATION
        , a.NLEG_NUMBER
        , a.CTLC_FROM
        , a.CTLC_TO
        , a.CARRIVAL_TIME
        , a.NDEPT_OFFSET
        , a.CHANDLING_TYPE
        , a.CHANDLING_DESC
        , a.CROUTING
        , a.COPCODE
        , a.CBOX_FROM
        , a.CBOX_TO
        , a.NFLIGHT_STATUS
        , a.CACCOUNT
        , a.CINFORMATION1
        , a.CINFORMATION2
        , a.NCOUNT_FLIGHT
        , a.CINPUT_SOURCE
        , a.NFREEZE
        , a.NHAS_AC_CHANGE
        , a.NFULL_CART_COUNT
        , a.NHALF_CART_COUNT
        , a.NCARRIER_COUNT
        , a.NOVEN_COUNT
        , a.NFREE_LOAD_COUNT
        , a.NGEN_COUNT
        , a.NCALC_COUNT
        , a.NEXPLOSION_COUNT
        , a.NDISTRIBUTION_COUNT
        , a.NFREEZE_COUNT
        , a.NDOCUMENTS_COUNT
        , a.NCLOSE_COUNT
        , a.NCAT_GROUP_KEY
        , a.NCAT_KEY
        , a.NEXT_CAT_KEY
        , a.DDEPARTURE_TIME_LOC
        , a.DISHWASH_0100
        , a.ASSEMBLY_0200
        , a.PRODUCTION_0300
        , a.PRODUCTION_FIXED
        , a.PRODUCTION_MULT
        , a.TRANSPORT_0500
        , a.FLIGHT_TOTAL
        , a.DISHWASH_PFD_PCT
        , a.ASSEMBLY_PFD_PCT
        , a.PRODUCTION_PFD_PCT
        , a.TRANSPORT_PFD_PCT
        , a.CCLASS
        , a.NBOOKING_CLASS
        , a.NVERSION
        , a.NPAX
        , a.NPAX_MEALS
        , a.NPAX_SPML
        , a.CLOS_GRP_CODE
        , a.CLOS_VAR
        , a.CLOS
        , a.Last_refresh

        , '0790' AS CUNIT_ALLOCATED    
        , CASE WHEN b.Department = 'Food'
             THEN a.CBASE_STANDARD_HOURS_PRODUCTION
                  * CAST(REPLACE(b.SFO, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
          END AS CBASE_STANDARD_HOURS_PRODUCTION,

        CASE WHEN b.Department = 'E&S'
             THEN a.CBASE_STANDARD_HOURS_DISHWASH
                  * CAST(REPLACE(b.SFO, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_DISHWASH,

        CASE WHEN b.Department = 'Delivery'
             THEN a.CBASE_STANDARD_HOURS_DELIVERY
                  * CAST(REPLACE(b.SFO, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_DELIVERY,

        CASE WHEN b.Department = 'Assembly'
             THEN a.CBASE_STANDARD_HOURS_ASSEMBLY
                  * CAST(REPLACE(b.SFO, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_ASSEMBLY
        
    FROM sjc_base AS a
    LEFT JOIN manpower_cube.`04_curated`.master_standard_hours_distribution AS b
      ON TRUNC(DDEPARTURE, 'MM') = b.Date
        AND a.CAIRLINE   = b.CbaseID
        AND b.ProfitCenterName LIKE '%0790%'
    WHERE CAST(NULLIF(REPLACE(b.SFO, '%', ''), '') AS DECIMAL(10,6)) > 0
),

/* ---------- OAK ROWS ---------- */
oak_rows AS (
    SELECT
       a.NRESULT_KEY
        , a.NAIRLINE_KEY
        , a.DDEPARTURE
        , a.NRESULT_KEY_GROUP
        , a.NTRANSACTION
        , a.CUNIT
        , a.CAIRLINE
        , a.NFLIGHT_NUMBER
        , a.CDEPARTURE_TIME
        , a.CRAMP_TIME
        , a.CKITCHEN_TIME
        , a.CACTYPE
        , a.CGALLEYVERSION
        , a.CCONFIGURATION
        , a.NLEG_NUMBER
        , a.CTLC_FROM
        , a.CTLC_TO
        , a.CARRIVAL_TIME
        , a.NDEPT_OFFSET
        , a.CHANDLING_TYPE
        , a.CHANDLING_DESC
        , a.CROUTING
        , a.COPCODE
        , a.CBOX_FROM
        , a.CBOX_TO
        , a.NFLIGHT_STATUS
        , a.CACCOUNT
        , a.CINFORMATION1
        , a.CINFORMATION2
        , a.NCOUNT_FLIGHT
        , a.CINPUT_SOURCE
        , a.NFREEZE
        , a.NHAS_AC_CHANGE
        , a.NFULL_CART_COUNT
        , a.NHALF_CART_COUNT
        , a.NCARRIER_COUNT
        , a.NOVEN_COUNT
        , a.NFREE_LOAD_COUNT
        , a.NGEN_COUNT
        , a.NCALC_COUNT
        , a.NEXPLOSION_COUNT
        , a.NDISTRIBUTION_COUNT
        , a.NFREEZE_COUNT
        , a.NDOCUMENTS_COUNT
        , a.NCLOSE_COUNT
        , a.NCAT_GROUP_KEY
        , a.NCAT_KEY
        , a.NEXT_CAT_KEY
        , a.DDEPARTURE_TIME_LOC
        , a.DISHWASH_0100
        , a.ASSEMBLY_0200
        , a.PRODUCTION_0300
        , a.PRODUCTION_FIXED
        , a.PRODUCTION_MULT
        , a.TRANSPORT_0500
        , a.FLIGHT_TOTAL
        , a.DISHWASH_PFD_PCT
        , a.ASSEMBLY_PFD_PCT
        , a.PRODUCTION_PFD_PCT
        , a.TRANSPORT_PFD_PCT
        , a.CCLASS
        , a.NBOOKING_CLASS
        , a.NVERSION
        , a.NPAX
        , a.NPAX_MEALS
        , a.NPAX_SPML
        , a.CLOS_GRP_CODE
        , a.CLOS_VAR
        , a.CLOS
        , a.Last_refresh

        , '1304' AS CUNIT_ALLOCATED        
        , CASE WHEN b.Department = 'Food'
             THEN a.CBASE_STANDARD_HOURS_PRODUCTION
                  * CAST(REPLACE(b.OAK, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
          END AS CBASE_STANDARD_HOURS_PRODUCTION,

        CASE WHEN b.Department = 'E&S'
             THEN a.CBASE_STANDARD_HOURS_DISHWASH
                  * CAST(REPLACE(b.OAK, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_DISHWASH,

        CASE WHEN b.Department = 'Delivery'
             THEN a.CBASE_STANDARD_HOURS_DELIVERY
                  * CAST(REPLACE(b.OAK, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_DELIVERY,

        CASE WHEN b.Department = 'Assembly'
             THEN a.CBASE_STANDARD_HOURS_ASSEMBLY
                  * CAST(REPLACE(b.OAK, '%', '') AS DECIMAL(10,6)) / 100
             ELSE 0
        END AS CBASE_STANDARD_HOURS_ASSEMBLY

    FROM sjc_base AS a
    LEFT JOIN manpower_cube.`04_curated`.master_standard_hours_distribution AS b
      ON TRUNC(DDEPARTURE, 'MM') = b.Date
        AND a.CAIRLINE   = b.CbaseID
        AND b.ProfitCenterName LIKE '%1304%'
    WHERE CAST(NULLIF(REPLACE(b.OAK, '%', ''), '') AS DECIMAL(10,6)) > 0
),

final AS (
    SELECT * FROM non_sjc
    UNION ALL
    SELECT * FROM sjc_redistributed
    UNION ALL
    SELECT * FROM sfo_rows
    UNION ALL
    SELECT * FROM oak_rows
)

SELECT *
FROM final