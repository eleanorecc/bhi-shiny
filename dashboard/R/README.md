# `R`

### `mapping.R`

**make_subbasin_sf** <br/> 
make spatial polygons dataframe obj with subbasin-aggregated goal scores <br/> 
@param subbasins_shp a shapefile read into R as a sp (spatial polygons) object; <br/> 
must have an attribute column with subbasin full names <br/> 
@param scores_csv scores dataframe with goal, dimension, region_id, year and score columns, <br/> 
e.g. output of ohicore::CalculateAll typically from calculate_scores.R <br/> 
@param dim the dimension the object/plot should represent, <br/> 
typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure' <br/> 
@param year the scenario year to filter the data to, by default the current assessment yearr <br/> 
@return list with (1) spatial polygons dataframe obj (2) dataframe, both with subbasin-aggregated goal scores <br/> 
<br/>
**make_rgn_sf** <br/> 
make spatial polygons dataframe obj with bhi-regions joined to goal scores <br/> 
@param bhi_rgns_shp a shapefile of the BHI regions, a sp (spatial polygons) object; <br/>
@param scores_csv scores dataframe with goal, dimension, region_id, year and score columns, <br/> 
e.g. output of ohicore::CalculateAll typically from calculate_scores.R <br/> 
@param dim the dimension the object/plot should represent, <br/> 
typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure' <br/> 
@param year the scenario year to filter the data to, by default the current assessment yearr <br/> 
@return (1) spatial polygons dataframe obj (2) dataframe, both with bhi-regions joined to goal scores <br/> 
<br/>
**leaflet_map** <br/> 
create leaflet map <br/> 
@param goal_code the two or three letter code indicating which goal/subgoal to create the plot for <br/> 
@param mapping_data_sp  spatial polygons dataframe associating scores with spatial polygons, <br/> 
i.e. having goal score and geometries information <br/> 
@param basins_or_rgns one of 'subbasins' or 'regions' to indicate which spatial units should be represented <br/> 
@param scores_csv scores dataframe with goal, dimension, region_id, year and score columns, <br/> 
e.g. output of ohicore::CalculateAll typically from calculate_scores.R <br/> 
@param dim the dimension the object/plot should represent, <br/> 
typically 'score' but could be any one of the scores.csv 'dimension' column elements e.g. 'trend' or 'pressure' <br/> 
@param year the scenario year to filter the data to, by default the current assessment year <br/> 
@param legend_title text to be used as the legend title <br/> 
@return leaflet map with BHI goal scores by BHI region or Subbasins <br/> 
<br/>

### `visualization.R`

**scores_barplot** <br/> 
create barplot to accompany maps <br/> 
create a barplot with subbasin scores, arranged vertically approximately north-to-south <br/> 
intended to present side-by-side with map, to show distances from reference points/room for improvement <br/> 
@param scores_csv scores dataframe with goal, dimension, region_id, year and score columns, <br/> 
e.g. output of ohicore::CalculateAll typically from calculate_scores.R <br/> 
@param basins_or_rgns one of 'subbasins' or 'regions' to indicate which spatial units should be represented <br/> 
@param goal_code the two or three letter code indicating which goal/subgoal to create the plot for <br/> 
@param dim the dimension the flowerplot petals should represent (typically OHI 'score') <br/> 
@param uniform_width if TRUE all subbasin bars will be the same width, otherwise a function of area <br/> 
<br/> 
@return html/plotly bar plot to use in shiny app adjacent to maps <br/> 
<br/>
