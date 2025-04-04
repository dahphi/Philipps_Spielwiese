prompt --application/pages/page_00010
begin
--   Manifest
--     PAGE: 00010
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.3'
,p_default_workspace_id=>2800197248760671
,p_default_application_id=>1210
,p_default_id_offset=>61532733767019240
,p_default_owner=>'ROMA_MAIN'
);
wwv_flow_imp_page.create_page(
 p_id=>10
,p_name=>'Karte'
,p_alias=>'KARTE'
,p_step_title=>'Karte'
,p_warn_on_unsaved_changes=>'N'
,p_html_page_onload=>'onload="start();"'
,p_autocomplete_on_off=>'OFF'
,p_html_page_header=>'<meta charset="utf-8"/>'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APP_IMAGES#leaflet.js',
'#APP_IMAGES#leaflet.draw.js',
'#APP_IMAGES#L.Control.Locate.min.js',
'#APP_IMAGES#turf.min.js',
'#APP_IMAGES#spin.min.js',
'',
'',
'#APP_IMAGES#leaflet.awesome-markers.js',
'#APP_IMAGES#leaflet-tilelayer-wmts.js'))
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var spinner;',
'var spinTargetElem = document.getElementById(''wwvFlowForm'');',
'var spinOptions = {',
'  lines: 13',
', length: 28',
', width: 14',
', radius: 42',
', scale: 1',
', corners: 1',
', color: ''#000''',
', opacity: 0.25',
', rotate: 0',
', direction: 1',
', speed: 1',
', trail: 60',
', fps: 20',
', zIndex: 2e9',
', className: ''spinner''',
', top: ''50%''',
', left: ''50%''',
', shadow: false',
', hwaccel: false',
', position: ''absolute''',
'}',
'',
'spinner = new Spinner(spinOptions);',
'',
'spinner.stop();',
'',
'var markerSelected = [];',
'var objkLayerGroup = new L.FeatureGroup();',
'var objkLayerGroupVc = new L.FeatureGroup();',
'var objkLayerGeoJson = new L.geoJSON();',
'',
'var markerSelectedTechnik = [];',
'var technikLayerGroup = new L.FeatureGroup();',
'',
'// Style Variablen',
'// Vertriebscluster',
'var objektVCFillColorSelected = ''red'';',
'var objektVCColorSelected     = ''red'';',
'var objektVCRadiusSelected= 1;',
'var objektVCWeightSelected= 3;',
'var objektVCOpacitySelected= 0.9;',
'var objektVCFillOpacitySelected= 0.5;',
'// Objekt',
'var objektFillColor           = ''#000000'';',
'var objektColor               = ''#000000'';',
'var objektRadius              = 1;  //3',
'var objektWeight              = 3; //3',
'var objektOpacity             = 1; //0.9',
'var objektFillOpacity         = 0.9; //0.9',
'var objektFillColorSelected   = ''#000000'';',
'var objektColorSelected       = ''#000000'';',
'var objektRadiusSelected      = 1; //6',
'var objektWeightSelected      = 3; // 3',
'var objektOpacitySelected     = 0.5;',
'var objektFillOpacitySelected = 0.5;',
'',
'// ObjektTechnik',
'var objektTechnikFillColor           = ''grey'';',
'var objektTechnikColor               = ''black'';',
'var objektTechnikRadius              = 16;',
'var objektTechnikWeight              = 3;',
'var objektTechnikOpacity             = 0.9;',
'var objektTechnikFillOpacity         = 0.9;',
'var objektTechnikFillColorSelected   = ''#ff0000'';',
'var objektTechnikColorSelected       = ''black'';',
'var objektTechnikRadiusSelected      = 16;',
'var objektTechnikWeightSelected      = 3;',
'var objektTechnikOpacitySelected     = 0.9;',
'var objektTechnikFillOpacitySelected = 0.9;',
'',
'',
'// container CSS-ID',
'const mapCssId = ''map'';',
'// coordinates',
'const latitude = 50.941278;',
'const longitude = 6.958281;',
'const latLng = L.latLng(latitude, longitude);',
'',
'',
'var South = 50.93997731002622;',
'var North = 50.942580070599774;',
'var West = 6.953440903516205;',
'var East = 6.963134406896027;',
'',
'$s(''P10_SOUTH'',South);',
'$s(''P10_NORTH'',North);',
'$s(''P10_WEST'',West);',
'$s(''P10_EAST'',East);',
'',
'const zoomDefault = 18;',
'const zoomMin = 8;',
'const zoomMax = 18;',
'',
'',
'var osmLink = ''<a href="https://mapproxy.netcologne.de/osm">NetCologne</a>'';',
'    ',
'var osmUrl = ''https://mapproxy.netcologne.de/osm/tiles/1.0.0/Mapnik_EPSG3857/{z}/{x}/{y}.png'',',
'    osmAttrib = ''&copy; '' + osmLink + '' Contributors'';',
'    ',
'var osmMap = L.tileLayer(osmUrl, {attribution: osmAttrib, ',
'//These should reduce memory usage',
'        unloadInvisibleTiles: true,',
'        updateWhenIdle: true,',
'        reuseTiles: true})',
'',
'osmMap.setOpacity(0.7);',
'',
'// initiate map',
'var map = new L.Map(''map'', {',
'	  minZoom: zoomMin,',
'	  maxZoom: zoomMax,',
'	  scrollWheelZoom: true,',
'	  fadeAnimation: false,',
'	  layers: [osmMap],',
'      doubleClickZoom: false',
'      //,drawControl: true ',
'    ',
'	});',
'',
'var pane250 = map.createPane("pane250").style.zIndex = 250; // between tiles and overlays',
'var pane450 = map.createPane("pane450").style.zIndex = 450; // between overlays and shadows',
'var pane620 = map.createPane("pane620").style.zIndex = 620; // between markers and tooltips',
'var pane800 = map.createPane("pane800").style.zIndex = 800; // above popups',
'',
'',
'',
'',
'map.zoomControl.setPosition(''topright'');',
'',
'// show map and center to coordinates',
'map.setView(latLng, zoomDefault); ',
'',
'var baseMaps = {',
'  //  "OpenStreetMap":aCheckGkLayerGroup',
'    "NC" :osmMap',
'};',
'',
'var overlayMaps = {',
'   "Objekt" : objkLayerGroup',
'    //,"Technikstandort" : technikLayerGroup,',
'    ',
'};',
'',
'//L.control.layers(null,overlayMaps,{collapsed: false}).addTo(map);',
'L.control.layers(null,null,{collapsed: false}).addTo(map);',
'',
'// Keine OBjekte anzeigen',
'//objkLayerGroup.addTo(map);',
'',
'// alle Layers erstmal entfernen',
'//map.clearLayers();',
'//map.removeLayer(technikLayerGroup);',
'',
'',
'',
'',
'',
'var myRenderer = L.canvas({ padding: 0.5 });',
'var myRenderer2 = L.canvas({ padding: 0.5 });',
'',
'',
'',
'// --------------------------------------------------------------------------------------------------------------------------------------------------------------',
'// Initialise the FeatureGroup to store editable layers',
'',
'var editableLayers = new L.FeatureGroup();',
'    map.addLayer(editableLayers);',
'    ',
'    var MyCustomMarker = L.Icon.extend({',
'        options: {',
'            shadowUrl: null,',
'            iconAnchor: new L.Point(12, 12),',
'            iconSize: new L.Point(24, 24),',
'            iconUrl: ''link/to/image.png''',
'        }',
'    });',
'    ',
'    var options = {',
'        position: ''topright'',',
'        draw: {',
'',
'            polygon: {',
'                allowIntersection: false, // Restricts shapes to simple polygons',
'                drawError: {',
'                    color: ''#e1e100'', // Color the shape will turn when intersects',
'                    message: ''<strong>Oh snap!<strong> you can\''t draw that!'' // Message that will show when intersect',
'                },',
'                ',
'                ',
'                shapeOptions: {',
'                    color: ''#549fd8'', //''#bada55''',
'                    opacity:0.9,',
'                    pane: ''pane250''',
'               ',
'                }',
'            },',
'            polyline:false,',
'            circle: false,',
'            circlemarker: false,',
'            rectangle: false,',
'            marker: false',
'     ',
'           ',
'        },',
'        edit: {',
'            featureGroup: editableLayers,//editableLayers, //REQUIRED!!',
'            remove: true',
'        }',
'    };',
'    ',
'    var drawControl = new L.Control.Draw(options);',
'    // Keine Anzeige der DRAW Controls',
'    //map.addControl(drawControl);',
'',
'',
'    map.on(''draw:editstart'', function (e) {',
'    ',
'		geojsonLayer.clearLayers();',
'     });',
'',
'    map.on(''draw:editstop'', function (e) {',
'    ',
'',
'        GetSelection(editableLayers );',
'',
'     });',
'',
'',
'    map.on(''draw:deletestop'', function (e) {',
'    ',
'	',
'            geojsonLayer.clearLayers();',
'     });',
'',
'',
'    map.on(L.Draw.Event.CREATED, function (e) {',
'        var type = e.layerType,',
'            layer = e.layer;',
'    ',
'        if (type === ''marker'') {',
'            layer.bindPopup(''A popup!'');',
'        }',
'    ',
'        if (type === ''polygon'') {',
'',
'',
'        editableLayers.clearLayers();',
'        editableLayers.addLayer(layer);',
'         console.log(''--- Polygon ---------------------'')',
'         console.log(layer.getLatLngs())',
'         console.log(''--- Polygon ---------------------'')',
'',
'         if (type !== ''circle'') {',
'            ',
'	    GetSelection(editableLayers );',
'',
'var shape = layer.toGeoJSON()',
'  var shape_for_db = JSON.stringify(shape);',
'        //console.log(shape_for_db);',
'',
'		}        ',
'                ',
'  ',
'  ',
'        }',
'        // Finally, show the poly as a geojson object in the console',
'        //console.log(JSON.stringify(geojson));',
'',
'    ',
'',
'',
'',
'        editableLayers.addLayer(layer);',
'      ',
'    });',
'',
'	function GetSelection(layer){',
'            var pts ;',
'            pts = objkLayerGeoJson.toGeoJSON(16)',
'',
'         var ptsWithin2= new L.geoJSON();',
'                     ',
'                     ',
'                     ',
'                     ptsWithin2 = turf.within(pts, layer.toGeoJSON(16));',
'',
'',
'',
'',
'',
'				alert(''Found '' + ptsWithin2.features.length + '' features'');	',
'           //console.log(JSON.stringify(ptsWithin2));',
'',
'',
'	',
'',
'                console.log(''----------'');',
'',
'',
'                for (var i = 0; i < ptsWithin2.features.length; i++) {',
'                    markerSelected.push(ptsWithin2.features[i].properties.hslfdnr);',
'                    }',
'',
'				drawSelection(ptsWithin2);',
'	};  ',
'',
'	function drawSelection(test){',
'	//Symbolize the Points',
'		var geojsonMarkerOptions = {',
'            fillColor: objektFillColorSelected,',
'                            color: objektColorSelected,',
'                            radius:objektRadiusSelected,',
'                            weight:objektWeightSelected,',
'                            opacity:objektOpacitySelected,',
'                            fillOpacity:objektFillOpacitySelected,',
'                            renderer: myRenderer,',
'                            pane: ''pane800''',
'                            		};',
'	',
'	',
'	geojsonLayer = L.geoJson(test, {',
'		pointToLayer: function(feature, latlng) {',
'			return L.circleMarker(latlng,  geojsonMarkerOptions );',
'		},',
'        ',
'		onEachFeature: function (feature, layer) {',
'             ',
'             layer.bindPopup( "<b>Objekt </b>" + feature.properties.hslfdnr +''<br>'' +''<b>Adresse</b> '' + feature.properties.adr, {closeOnClick: false,autoClose: false, className: "my-label", offset: [0, 0] })',
'                                                 .on(''dblclick'', onDblClick);',
'',
'           ',
'		}',
'	});',
'	',
'	map.addLayer(geojsonLayer);',
'',
'',
'',
' ',
'    geojsonLayer.bringToFront();',
'',
'	',
'	}',
'	',
'',
'',
'// --------------------------------------------------------------------------------------------------------------------------------------------------------------',
'',
'',
'// =========================================================',
'function loadPolygon() {',
'var jsonDrawn = ''{"type":"Feature","properties":{},"geometry":{"type":"Polygon","coordinates":[[[6.955885,50.941806],[6.956626,50.940515],[6.959732,50.940724],[6.959619,50.941982],[6.955885,50.941806]]]}}'';',
'',
'',
'function getDrawnItems() {',
'        var json = new L.GeoJSON(JSON.parse(jsonDrawn), {',
'            pointToLayer: function (feature, latlng) {',
'                switch (feature.geometry.type) {',
'                    case ''Polygon'':',
'                        return L.polygon(latlng);',
'                    case ''LineString'':',
'                        return L.polyline(latlng);',
'                    case ''Point'':',
'                        return L.marker(latlng);',
'                    default:',
'                        return;',
'                }',
'            },',
'            onEachFeature: function (feature, layer) {',
'                layer.addTo(editableLayers);',
'            }',
'        });',
'    };',
'',
'   getDrawnItems();',
'   GetSelection(editableLayers);',
'}',
'// =========================================================',
'',
'',
'function onDblClick(e) {',
'//alert(''DbvlClick'');',
'    if (this.options.customTag == ''OBJK'')',
'    {',
'        if (markerSelected.length == 0)',
'        {',
'            // alert(this.getLatLng());',
'            this.setStyle({ ',
'                            fillColor: objektFillColorSelected,',
'                            color: objektColorSelected,',
'                            radius:objektRadiusSelected,',
'                            weight:objektWeightSelected,',
'                            opacity:objektOpacitySelected,',
'                            fillOpacity:objektFillOpacitySelected',
'',
'            });',
'            //alert(this.options.customId);',
'            markerSelected.push(this.options.customId);',
'        }',
'        else',
'        {',
'            if (markerSelected.indexOf(this.options.customId) > -1 )',
'            { ',
'                // alert(this.getLatLng());',
'                this.setStyle({ ',
'                    fillColor: objektFillColor,',
'                    color: objektColor,',
'                    radius:objektRadius,',
'                    weight:objektWeight,',
'                    opacity:objektOpacity,',
'                    fillOpacity:objektFillOpacity',
'',
'                });            ',
'                markerSelected.pop(this.options.customId);',
'            }',
'            else',
'            {',
'                this.setStyle({ ',
'                            fillColor: objektFillColorSelected,',
'                            color: objektColorSelected,',
'                            radius:objektRadiusSelected,',
'                            weight:objektWeightSelected,',
'                            opacity:objektOpacitySelected,',
'                            fillOpacity:objektFillOpacitySelected',
'                });',
'                //alert(this.options.customId);',
'                markerSelected.push(this.options.customId);',
'            }',
'        }',
'        ',
'    }   ',
'    ',
' ',
'',
'',
'}',
'',
'',
'/*',
'',
'map.on(''zoomend'', function () {',
'    if (map.getZoom() < 16 && map.hasLayer(objkLayerGroup)) {',
'        map.removeLayer(objkLayerGroup);',
'    }',
'    if (map.getZoom() >= 16 && map.hasLayer(objkLayerGroup) == false)',
'    {',
'        map.addLayer(objkLayerGroup);',
'    }   ',
'});',
'',
'map.on(''dragend'', function onDragEnd(){',
'    var width = map.getBounds().getEast() - map.getBounds().getWest();',
'    var height = map.getBounds().getNorth() - map.getBounds().getSouth();',
'',
'    var SouthEast = map.getBounds().getSouthEast();',
'    var NorthEast = map.getBounds().getNorthEast();',
'    var SouthWest = map.getBounds().getSouthWest();',
'    var NorthWest = map.getBounds().getNorthWest() ;',
'',
'    South = map.getBounds().getSouth();',
'    North = map.getBounds().getNorth();',
'    West = map.getBounds().getWest();',
'    East = map.getBounds().getEast() ;',
'',
'    $s(''P10_SOUTH'',South);',
'    $s(''P10_NORTH'',North);',
'    $s(''P10_WEST'',West);',
'    $s(''P10_EAST'',East);',
'    start();',
'    });',
'*/'))
,p_css_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#APP_IMAGES#leaflet.css',
'#APP_IMAGES#leaflet.draw.png.css',
'#APP_IMAGES#L.Control.Locate.min.css',
'#APP_IMAGES#font-awesome.min.css',
'#APP_IMAGES#leaflet.awesome-markers.css'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'',
'.myfa{',
'    vertical-align:baseline!important;}',
'',
'.apex-icons-fontapex .fa:before {',
'    vertical-align: middle!important;',
'}',
'',
'',
'.t-ContentBlock--lightBG .t-ContentBlock-body, .t-Region, .t-Region-header {',
'    background-color: #F8F8F8;',
'}',
'',
'.t-Region {',
'    border: 0px solid rgba(0,0,0,0); ',
'}',
'',
'',
'.labelClass{',
'white-space:nowrap;',
'text-shadow: 0 0 0.1em black, 0 0 0.1em black,',
'0 0 0.1em black,0 0 0.1em black,0 0 0.1em;',
'color: yellow',
'}',
'',
'.gee-red{',
'background-color:#c0504d!important;',
'color:white!important;',
'}',
'',
'.gee-green{',
'background-color:#9bbb59!important;',
'color:white!important;',
'}',
'',
'.gee-yellow{',
'background-color:#f79646!important;',
'color:black!important;',
'}',
'',
'.gee-grey{',
'background-color:#D9D9D9!important;',
'color:black!important;',
'}',
'',
'',
'.t-Form-fieldContainer--floatingLabel .apex-item-display-only {',
'',
'    min-height: 6.4rem;',
'}',
'',
'',
''))
,p_page_template_options=>'#DEFAULT#'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(242058882226233705)
,p_plug_name=>'Spalte 1'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>30
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(242059114767233708)
,p_plug_name=>'Auswahl'
,p_parent_plug_id=>wwv_flow_imp.id(242058882226233705)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(242059912069233716)
,p_plug_name=>'Collection '
,p_parent_plug_id=>wwv_flow_imp.id(242059114767233708)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(242060144294233718)
,p_name=>'Collection - SMW_OBJEKTE'
,p_parent_plug_id=>wwv_flow_imp.id(242059912069233716)
,p_template=>wwv_flow_imp.id(236557045854961955)
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select distinct c001 from apex_collections',
'where collection_name = ''SMW_OBJEKTE'';'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(236583898978961966)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(234346214341913732)
,p_query_column_id=>1
,p_column_alias=>'C001'
,p_column_display_sequence=>10
,p_column_heading=>'C001'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(242489935313876107)
,p_name=>'Collection - SMW_OBJEKTE_TECHNIK'
,p_parent_plug_id=>wwv_flow_imp.id(242059912069233716)
,p_template=>wwv_flow_imp.id(236557045854961955)
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_new_grid_row=>false
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select seq_id,n001 from apex_collections',
'where collection_name = ''SMW_OBJEKTE_TECHNIK'';'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(236583898978961966)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(236666549369969115)
,p_query_column_id=>1
,p_column_alias=>'SEQ_ID'
,p_column_display_sequence=>20
,p_column_heading=>'Seq Id'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(236666143206969114)
,p_query_column_id=>2
,p_column_alias=>'N001'
,p_column_display_sequence=>10
,p_column_heading=>'N001'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(259719611045016815)
,p_plug_name=>'Karte'
,p_region_name=>'HeadingKarte'
,p_parent_plug_id=>wwv_flow_imp.id(242058882226233705)
,p_region_template_options=>'#DEFAULT#:t-Form--noPadding'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(259719658059016816)
,p_plug_name=>'Karte Leaflet'
,p_parent_plug_id=>wwv_flow_imp.id(259719611045016815)
,p_region_template_options=>'#DEFAULT#:t-Region--noPadding:t-Region--removeHeader:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<script type="text/javascript">',
'function start(){',
'',
'',
'',
'  var array = [];',
'  var retval;',
'  var posKunde = new Array;',
'  var lo;',
'  var la;',
'  var strasse;',
'  var gee_farbe;',
'  var ausbaugebiet;',
'',
'  var loOvst;',
'  var laOvst;',
'  var loKvz;',
'  var laKvz;',
'  var loKunde;',
'  var laKunde;',
'  var gesellschaft;',
'  ',
'  var loadDaten = 0;',
'',
'  ',
'',
'  var markerArray = [];',
'  //var markers = L.markerClusterGroup();',
'',
'  var ptext;',
'  //var layerControl = false;',
'    ',
'  //Extend the Default marker class',
'  var RedIcon = L.Icon.Default.extend({',
'                options: {',
'            	    iconUrl: ''#APP_IMAGES#red-marker.png'' ,',
'                   shadowUrl: ''#APP_IMAGES#marker-shadow.png'',',
'                   iconSize:     [28, 38], // size of the icon',
'                   shadowSize:   [28, 38], // size of the shadow',
'                   iconAnchor:   [18, 38], // point of the icon which will correspond to marker''s location',
'                   shadowAnchor: [12, 38], // the same for the shadow',
'                   popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor',
'               }',
'  });',
'  var redIcon = new RedIcon();',
'  ',
'  var redMarker = L.AwesomeMarkers.icon({',
'    icon: ''coffee'',',
'    markerColor: ''red''',
'  });',
'',
'  var YellowIcon = L.Icon.Default.extend({',
'                options: {',
'            	    iconUrl: ''#APP_IMAGES#yellow-marker.png'' ,',
'                   shadowUrl: ''#APP_IMAGES#marker-shadow.png'',',
'                   iconSize:     [28, 38], // size of the icon',
'                   shadowSize:   [28, 38], // size of the shadow',
'                   iconAnchor:   [18, 38], // point of the icon which will correspond to marker''s location',
'                   shadowAnchor: [12, 38], // the same for the shadow',
'                   popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor',
'               }',
'  });',
'  var yellowIcon = new YellowIcon();',
'',
'  var GreenIcon = L.Icon.Default.extend({',
'                options: {',
'            	    iconUrl: ''#APP_IMAGES#green-marker.png'' ,',
'                   shadowUrl: ''#APP_IMAGES#marker-shadow.png'',',
'                   iconSize:     [28, 38], // size of the icon',
'                   shadowSize:   [28, 38], // size of the shadow',
'                   iconAnchor:   [18, 38], // point of the icon which will correspond to marker''s location',
'                   shadowAnchor: [12, 38], // the same for the shadow',
'                   popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor',
'               }',
'  });',
'  var greenIcon = new GreenIcon();',
'',
'var myIcon = L.divIcon({html: ''PV<i class="fa fa-truck fa-4x" style="color: red"></i>'',className: ''myDivIcon'',iconSize: [40, 40]});',
'',
'//aCheckGkLayerGroup.clearLayers();',
'',
'objkLayerGroup.clearLayers();',
'        ',
'var feature = objkLayerGroup.feature = objkLayerGroup.feature || {};',
'feature.type = "Feature";',
'feature.properties = feature.properties || {};',
'',
'var divIcon = L.divIcon({ ',
'className: "labelClass",',
'html: "<span style=''color:blue;''>textToDisplay</span>"',
'})',
'',
'',
'if (South == null || South == '''')',
'{',
'',
'South = 50.93997731002622;',
'North = 50.942580070599774;',
'West = 6.953440903516205;',
'East = 6.963134406896027;',
'',
'',
'}',
'$s(''P10_SOUTH'',South);',
'$s(''P10_NORTH'',North);',
'$s(''P10_WEST'',West);',
'$s(''P10_EAST'',East);',
'',
'//alert($v(''P10_SOUTH''));',
'',
'',
'//spinner = new Spinner(spinOptions).spin(spinTargetElem);',
'spinner.spin(spinTargetElem);',
'',
'apex.server.process (   ',
'     "LOAD_OBJEKT_COLLECTION",   ',
'     {},',
'      {   dataType: ''text''',
'        , success: function( pData ) { ',
'',
'',
'',
'',
'                                      // alert(pData);',
'                                       if (pData.includes(''ORA-20010''))',
'                                       {',
'                                           alert(pData);',
'                                      // alert (''Fehler beim Abruf der Daten!'')',
'                                       }',
'                                       else {',
'                                       ',
'                            ',
'',
'',
'                                           //L.control.scale().addTo(map);',
'',
'',
'                                           //alert($v("P0_HAUS_LFD_NR"));',
'                                           //if ($v("P0_HAUS_LFD_NR") )',
'                                           loadDaten = 0;',
'                                            if (true)',
'                                            {',
'                                           posKunde = pData.split(";");',
'                                           //alert(posKunde);',
'                                           for (var x=0; x < posKunde.length; x+=5) {',
'                                         ',
'                                  ',
'                                               lo = posKunde[x];',
'                                               la = posKunde[x+1];',
'                                               ausbaugebiet = posKunde[x+2];',
'                                               hauslfdnr = posKunde[x+3];',
'                                               adresse = posKunde[x+4];',
'',
'                                               //alert(ausbaugebiet);',
'',
'                                                // Marker Color :  ''red'', ''darkred'', ''orange'', ''green'', ''darkgreen'', ''blue'', ''purple'', ''darkpurple'', ''cadetblue''',
'',
'                                               if (lo != '''' && la != '''' && x%5 == 0)  ',
'                                               {',
'                                                 ',
'                                                   loadDaten = 1;',
'                                                   ',
'                                                   if (ausbaugebiet == ''OBJK'')',
'                                                   {',
'                                                      if ( markerSelected.indexOf(hauslfdnr)>-1)',
'                                                      {',
'                                                      L.circleMarker([lo.replace('','',''.''),la.replace('','',''.'')], {customId: hauslfdnr,customTag:''OBJK'',renderer: myRenderer,riseOnHover: true,pane: ''pane620''})',
'                                                          .addTo(objkLayerGroup)',
'                                                          ',
'                                                          .setStyle({ ',
'                                                                        fillColor: objektFillColorSelected,',
'                                                                        //color: objektColorSelected,',
'                                                                        radius:objektRadiusSelected,',
'                                                                        weight:objektWeightSelected,',
'                                                                        opacity:objektOpacitySelected,',
'                                                                        fillOpacity:objektFillOpacitySelected',
'                                                                    })',
'                                                         .bindPopup( "<b>Objekt</b>" + "<br>" + adresse + "<br>" + "Hlfdnr: " + hauslfdnr + "<br>" + lo.replace('','',''.'') + '' '' + la.replace('','',''.''), {closeOnClick: false,autoClose: false, className: "m'
||'y-label", offset: [0, 0] }).on(''dblclick'', onDblClick)',
'                                                                ;',
'                                                        //feature.properties["hslfdfnr"] = hauslfdnr;',
'',
'                                                        ',
'                            var newMarker = L.circleMarker([lo.replace('','',''.''),la.replace('','',''.'')],{renderer: myRenderer,pane: ''pane800''});',
'                            newMarker.feature = { ',
'                                type: ''Feature'', ',
'                                properties: { hslfdnr: hauslfdnr ,adr: adresse}, ',
'                                geometry: {type: ''Point'', coordinates:[lo.replace('','',''.''),la.replace('','',''.'')] } ',
'                            };',
'                            newMarker.addTo(objkLayerGeoJson);',
'                            //objkLayerGeoJson',
'                                                      }',
'                                                      else',
'                                                        {',
'                                                      L.circleMarker([lo.replace('','',''.''),la.replace('','',''.'')], {customId: hauslfdnr,customTag:''OBJK'',renderer: myRenderer,riseOnHover: true,pane: ''pane620''})',
'                                                          .addTo(objkLayerGroup)',
'                                                          .setStyle({ ',
'                                                                        fillColor: objektFillColor,',
'                                                                        //color: objektColor,',
'                                                                        radius:objektRadius,',
'                                                                        weight:objektWeight,',
'                                                                        opacity:objektOpacity,',
'                                                                        fillOpacity:objektFillOpacity',
'                                                                    })',
unistr('                                                         // .bindPopup( "<b>Objektkl\00E4rung</b>" + "<br>"+ strasse + "", {closeOnClick: false,autoClose: false, className: "my-label", offset: [0, 0] }).openPopup();'),
'                                                         .bindPopup( "<b>Objekt</b>" + "<br>" + adresse+ "<br>" + "Hlfdnr: " + hauslfdnr + "<br>" + lo.replace('','',''.'') + '' '' + la.replace('','',''.''), {closeOnClick: false,autoClose: false, className: "my'
||'-label", offset: [0, 0] }).on(''dblclick'', onDblClick)',
'                                                         ',
'                                                                ;',
'',
'                                                            //feature.properties["hslfdfnr"] = hauslfdnr;',
'',
'',
'                            var newMarker = L.circleMarker([lo.replace('','',''.''),la.replace('','',''.'')],{renderer: myRenderer,pane: ''pane800''});',
'                                                 ',
'                            newMarker.feature = { ',
'                                type: ''Feature'', ',
'                                properties: { hslfdnr: hauslfdnr ,adr: adresse}, ',
'                                geometry: {type: ''Point'', coordinates:[lo.replace('','',''.''),la.replace('','',''.'')] }  ',
'                            };',
'                            newMarker.addTo(objkLayerGeoJson);',
'',
'                                                        }',
'',
'                                                   }',
'                                                   ',
'                                                   ',
'                                                   ',
'                                              ',
'                                                   ',
'                                                   ',
'                                                   ',
'                                                }   ',
'                                           }',
'                                          ',
'                                           ',
'                                          ',
'                                           ',
'                                         }',
'                                         ',
'                                         ',
'                                     }',
'                                     ',
'                                     ',
'                                      spinner.stop();    ',
'                                       ',
'                                    }',
'             , error: function(pData, err, message) {   ',
'             alert(message);',
'             spinner.stop();',
'          }   ',
'',
'     ',
'     });',
'',
'',
unistr('   //   var overlays = {"Objektkl\00E4rung": objkLayerGroup      };'),
'   //   map.addLayer(objkLayerGroup);',
'',
'   }',
'',
'',
'function start_vertriebscluster(vCId){',
'  var array = [];',
'  var retval;',
'  var posKunde = new Array;',
'  var lo;',
'  var la;',
'  var strasse;',
'  var gee_farbe;',
'  var ausbaugebiet;',
'',
'  var loOvst;',
'  var laOvst;',
'  var loKvz;',
'  var laKvz;',
'  var loKunde;',
'  var laKunde;',
'  var gesellschaft;',
'  ',
'  var loadDaten = 0;',
'',
'  ',
'',
'  var markerArray = [];',
'  //var markers = L.markerClusterGroup();',
'',
'  var ptext;',
'  //var layerControl = false;',
'    ',
'  ',
'$s(''P10_VC_ID'',vCId);',
'console.log($v(''P10_VC_ID''));',
'',
'objkLayerGroupVc.clearLayers();',
'',
'',
'var divIcon = L.divIcon({ ',
'className: "labelClass",',
'html: "<span style=''color:blue;''>textToDisplay</span>"',
'})',
'',
'var markerArray = []; //create new markers array',
'//var markers = L.markerClusterGroup();',
'',
'//spinner = new Spinner(spinOptions).spin(spinTargetElem);',
'spinner.spin(spinTargetElem);',
'',
'apex.server.process (   ',
'     "LOAD_VERMARKTUNGSCLUSTER",   ',
'     {x01:vCId},',
'      {   dataType: ''text''',
'        , success: function( pData ) { ',
'        ',
'                                     //  alert(pData);',
'                                       if (pData.includes(''ORA-20010''))',
'                                       {',
'                                           alert(pData);',
'                                      // alert (''Fehler beim Abruf der Daten!'')',
'                                       }',
'                                       else {',
'                                           //L.control.scale().addTo(map);',
'',
'',
'                                           //alert($v("P0_HAUS_LFD_NR"));',
'                                           //if ($v("P0_HAUS_LFD_NR") )',
'                                           loadDaten = 0;',
'                                            if (true)',
'                                            {',
'                                           posKunde = pData.split(";");',
'                                           //alert(posKunde);',
'                                           for (var x=0; x < posKunde.length; x+=5) {',
'                                         ',
'                                  ',
'                                               lo = posKunde[x];',
'                                               la = posKunde[x+1];',
'                                               ausbaugebiet = posKunde[x+2];',
'                                               hauslfdnr = posKunde[x+3];',
'                                               adresse = posKunde[x+4];',
'',
'                                               //alert(ausbaugebiet);',
'',
'                                                // Marker Color :  ''red'', ''darkred'', ''orange'', ''green'', ''darkgreen'', ''blue'', ''purple'', ''darkpurple'', ''cadetblue''',
'',
'                                               if (lo != '''' && la != '''' && x%5 == 0)  ',
'                                               {',
'                                                   ',
'                                                   loadDaten = 1;',
'                                                   ',
'                                                   if (ausbaugebiet == ''VERMARKTUNGSCLUSTER'')',
'                                                   {',
'                                                     ',
'                                                      var marker = L.circleMarker([lo.replace('','',''.''),la.replace('','',''.'')], {customId: hauslfdnr,customTag:''VERTRIEBSCLUSTER'',renderer: myRenderer})',
'                                                          .setStyle({ ',
'                                                                        fillColor: objektVCFillColorSelected,',
'                                                                        color: objektVCColorSelected,',
'                                                                        radius:objektVCRadiusSelected,',
'                                                                        weight:objektVCWeightSelected,',
'                                                                        opacity:objektVCOpacitySelected,',
'                                                                        fillOpacity:objektVCFillOpacitySelected',
'                                                                    })',
'                                                         .bindPopup( "<b>Objekt</b>" + "<br>" + adresse + "<br>" + "Hlfdnr: " + hauslfdnr, {closeOnClick: false,autoClose: false, className: "my-label", offset: [0, 0] }).on(''dblclick'', onDblClick)',
'                                                                ;',
'                                                          //.addTo(objkLayerGroupVc)',
'',
'                                                      objkLayerGroupVc.addLayer(marker);',
'',
'                                                    markerArray.push(marker); //add each markers to array',
'',
'                                                   }',
'                                                   ',
'                                                   ',
'                                                   ',
'                                                ',
'                                                   ',
'                                                   ',
'                                                   ',
'                                                }   ',
'                                           }',
'                                           if (markerArray.length !== 0)',
'                                           {',
'',
'                                           var group = L.featureGroup(markerArray); //add markers array to featureGroup',
'                                              map.addLayer(objkLayerGroupVc);',
'                                            map.fitBounds(group.getBounds());',
'                                           }',
'',
'                                            spinner.stop();',
'                                          ',
'                                           ',
'                                         }',
'                                         ',
'                                         ',
'                                     }',
'                                     ',
'                                     ',
'                                        ',
'                                       ',
'                                    }',
'             , error: function(pData, err, message) {   ',
'             alert(message);',
'             spinner.stop();',
'          }   ',
'',
'     ',
'     });',
'',
'   ',
'  ',
'   // map.fitBounds(objkLayerGroupVc.getBounds());',
'   //var bounds = L.latLngBounds(objkLayerGroupVc);',
'   //map.fitBounds(bounds);//works!',
'   }',
'</script>'))
,p_plug_header=>'<div id="map" style="left:0px; top:0px;  height: 730px;"></div>'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(242061591065233732)
,p_plug_name=>'Vermarktungscluster'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>10
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(243808192806178703)
,p_plug_name=>'Adresse'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>wwv_flow_imp.id(236557045854961955)
,p_plug_display_sequence=>20
,p_include_in_reg_disp_sel_yn=>'Y'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(264869793481905330)
,p_plug_name=>'P110_PAGE_ITEMS'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>wwv_flow_imp.id(236525997957961945)
,p_plug_display_sequence=>1
,p_include_in_reg_disp_sel_yn=>'Y'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(236664560298969108)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(242061591065233732)
,p_button_name=>'P10_BTN_SMW_FTTB_AUSWAHL'
,p_button_static_id=>'P110_BTN_SMW_FTTB_AUSWAHL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('Auswahl \00FCbernehmen')
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-clipboard-check'
,p_required_patch=>wwv_flow_imp.id(237797642514829750)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(238197585550208048)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(259719611045016815)
,p_button_name=>'P10_BTN_LOAD_POLYGON'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>'Load Polygon'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(238198038585208053)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(259719611045016815)
,p_button_name=>'P10_BTN_LOAD_VC'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>wwv_flow_imp.id(236622160639961985)
,p_button_image_alt=>'Vertriebscluster laden'
,p_button_position=>'BELOW_BOX'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(236673940901969123)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(243808192806178703)
,p_button_name=>'P10_ADR_SUCHEN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--iconLeft:t-Button--stretch:t-Button--gapTop'
,p_button_template_id=>wwv_flow_imp.id(236622277180961985)
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Suchen'
,p_button_alignment=>'RIGHT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
,p_grid_new_row=>'N'
,p_grid_column=>12
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236669667257969120)
,p_name=>'P10_SOUTH'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236669995947969120)
,p_name=>'P10_NORTH'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236670435000969121)
,p_name=>'P10_WEST'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236670836618969121)
,p_name=>'P10_EAST'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236671292773969121)
,p_name=>'P10_SMW_OBJEKTE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236672054394969122)
,p_name=>'P10_SST_TYP'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236672416902969122)
,p_name=>'P10_SMW_FEHLER'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236672892354969122)
,p_name=>'P10_ADR_RW'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236673260067969122)
,p_name=>'P10_ADR_HW'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(236674306377969123)
,p_name=>'P10_ADR_HAUS_LFD_NR'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(243808192806178703)
,p_prompt=>'HAUS_LFD_NR'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_colspan=>2
,p_grid_column=>1
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(238197982021208052)
,p_name=>'P10_VC_ID'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(264869793481905330)
,p_display_as=>'NATIVE_HIDDEN'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(238198410347208057)
,p_name=>'P10_VC'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(242061591065233732)
,p_prompt=>'Vermarktungscluster'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'select bezeichnung d, vc_lfd_nr r from VERMARKTUNGSCLUSTER'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>12
,p_grid_column=>1
,p_field_template=>wwv_flow_imp.id(236619619312961984)
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs:t-Form-fieldContainer--xlarge'
,p_lov_display_extra=>'YES'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(236675497068969127)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_SOUTH'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236676018111969129)
,p_event_id=>wwv_flow_imp.id(236675497068969127)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P10_SOUTH'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(236681017189969133)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_NORTH'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236681591052969133)
,p_event_id=>wwv_flow_imp.id(236681017189969133)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P10_NORTH'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(236677349397969130)
,p_name=>'New_2'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_WEST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236677812259969130)
,p_event_id=>wwv_flow_imp.id(236677349397969130)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P10_WEST'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(236676450919969129)
,p_name=>'New_3'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_EAST'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236676919927969130)
,p_event_id=>wwv_flow_imp.id(236676450919969129)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'NULL;'
,p_attribute_02=>'P10_EAST'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(236681992080969133)
,p_name=>'Click P10_BTN_SMW_FTTB_AUSWAHL'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(236664560298969108)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236682417032969133)
,p_event_id=>wwv_flow_imp.id(236681992080969133)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'console.log(markerSelected);',
'$s("P10_SMW_OBJEKTE",markerSelected);',
'//$s("P10_SMW_OBJEKTE_TECHNIK",markerSelectedTechnik );',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(236678282832969130)
,p_name=>'Change P10_SMW_FTTB_OBJEKTE'
,p_event_sequence=>60
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_SMW_OBJEKTE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236679281791969131)
,p_event_id=>wwv_flow_imp.id(236678282832969130)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_array wwv_flow_t_varchar2;',
'',
'',
'    l_seq   APEX_APPLICATION_GLOBAL.VC_ARR2;',
'    l_n001  APEX_APPLICATION_GLOBAL.VC_ARR2;',
'',
'begin',
'',
'    APEX_COLLECTION.TRUNCATE_COLLECTION(',
'        p_collection_name => ''SMW_OBJEKTE'');',
'',
'',
'    l_array := apex_string.split( :P10_SMW_OBJEKTE, '','' );',
'    for i in 1 .. l_array.count loop',
'        --dbms_output.put_line( apex_string.format( ''element at index %s: %s'', i, l_array(i) ) );',
'        /*',
'        APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''SMW_OBJEKTE'',',
'        p_n001            => l_array(i) );',
'        */',
'        l_seq(i) := i;',
'',
'        l_n001(i) := l_array(i) ;',
'',
'    end loop;',
'',
'',
'        APEX_COLLECTION.MERGE_MEMBERS(',
'        p_collection_name => ''SMW_OBJEKTE'',',
'        p_seq => l_seq,',
'        p_c001 => l_n001,',
'        p_init_query => NULL',
'     );',
'',
'',
'end;'))
,p_attribute_02=>'P10_SMW_OBJEKTE'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236678705448969131)
,p_event_id=>wwv_flow_imp.id(236678282832969130)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(242060144294233718)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(236683331312969134)
,p_name=>'Change P10_SMW_OBJEKTE_TECHNIK'
,p_event_sequence=>70
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_SMW_OBJEKTE_TECHNIK'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236683810309969134)
,p_event_id=>wwv_flow_imp.id(236683331312969134)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    l_array wwv_flow_t_varchar2;',
'begin',
'',
'    APEX_COLLECTION.TRUNCATE_COLLECTION(',
'        p_collection_name => ''SMW_OBJEKTE_TECHNIK'');',
'',
'',
'    l_array := apex_string.split( :P10_SMW_OBJEKTE_TECHNIK, '','' );',
'    for i in 1 .. l_array.count loop',
'        --dbms_output.put_line( apex_string.format( ''element at index %s: %s'', i, l_array(i) ) );',
'        APEX_COLLECTION.ADD_MEMBER(',
'        p_collection_name => ''SMW_OBJEKTE_TECHNIK'',',
'        p_n001            => l_array(i) );',
'    end loop;',
'',
'',
'end;'))
,p_attribute_02=>'P10_SMW_OBJEKTE_TECHNIK'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236684349019969134)
,p_event_id=>wwv_flow_imp.id(236683331312969134)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(242489935313876107)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(236679693687969132)
,p_name=>'Click P10_ADR_SUCHEN'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(236673940901969123)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236680127395969132)
,p_event_id=>wwv_flow_imp.id(236679693687969132)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare  ',
'     vcHw           varchar2(4000);',
'     vcRw           varchar2(4000);',
'     ',
'begin ',
'    begin ',
'        select  rw, hw ',
'        into vcRw, vcHw',
'        FROM strav.v_a1_nc_na_adressen v ',
'        WHERE haus_lfd_nr = :P10_ADR_HAUS_LFD_NR',
'        ;  ',
'',
'        apex_util.set_session_state(''P10_ADR_RW'', replace(vcRw,'','',''.''));',
'        apex_util.set_session_state(''P10_ADR_HW'', replace(vcHw,'','',''.''));',
'',
'    exception',
'        when others then ',
'            vcHw := NULL;',
'            vcRw := NULL;',
'    end;',
'',
'end;'))
,p_attribute_02=>'P10_ADR_HAUS_LFD_NR'
,p_attribute_03=>'P10_ADR_RW,P10_ADR_HW'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(236680693828969133)
,p_event_id=>wwv_flow_imp.id(236679693687969132)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var latLng = L.latLng($v(''P10_ADR_HW''), $v(''P10_ADR_RW''));',
'map.setView(latLng, 18); ',
'',
unistr('// bei FTTH (ONT) wird das Array geleert, da nur ein Objekt ausgew\00E4hlt werden darf'),
'if ($v(''P0_SST_TYP'') == ''FTTH'')',
'{',
'markerSelected.pop();',
'}',
'',
'markerSelected.push($v(''P10_ADR_HAUS_LFD_NR''));',
'//alert($v(''P10_ADR_HAUS_LFD_NR''));',
'var SouthEast = map.getBounds().getSouthEast();',
'    var NorthEast = map.getBounds().getNorthEast();',
'    var SouthWest = map.getBounds().getSouthWest();',
'    var NorthWest = map.getBounds().getNorthWest() ;',
'',
'    South = map.getBounds().getSouth();',
'    North = map.getBounds().getNorth();',
'    West = map.getBounds().getWest();',
'    East = map.getBounds().getEast() ;',
'',
'    $s(''P10_SOUTH'',South);',
'    $s(''P10_NORTH'',North);',
'    $s(''P10_WEST'',West);',
'    $s(''P10_EAST'',East);',
'    start();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(238197669748208049)
,p_name=>'New_4'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(238197585550208048)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238197758457208050)
,p_event_id=>wwv_flow_imp.id(238197669748208049)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'loadPolygon();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(238198185644208054)
,p_name=>'New_5'
,p_event_sequence=>100
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(238198038585208053)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238198347606208056)
,p_event_id=>wwv_flow_imp.id(238198185644208054)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'start_vertriebscluster(4);'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(238198552981208058)
,p_name=>'Vertriebscluster laden'
,p_event_sequence=>110
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P10_VC'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(238198680759208059)
,p_event_id=>wwv_flow_imp.id(238198552981208058)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'start_vertriebscluster($v(''P10_VC''));'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(236674717354969126)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>unistr('Auswahl \00FCberpr\00FCfen')
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'begin',
'    if (:P10_SMW_OBJEKTE_TECHNIK is null',
'        ',
'        )',
'    then ',
'',
unistr('        apex_util.set_session_state(''P10_SMW_FEHLER'',''Keinen Technikstandort ausgew\00E4hlt!'');'),
'',
'    end if;',
'',
'    if (:P10_SMW_OBJEKTE is null',
'        )',
'    then ',
'',
unistr('        apex_util.set_session_state(''P10_SMW_FEHLER'',''Kein Haus ausgew\00E4hlt!'');'),
'',
'    end if;',
'',
'    if (:P10_SMW_OBJEKTE_TECHNIK is null or :P10_SMW_OBJEKTE is null)',
'    then',
'       -- return false;',
'       raise_application_error(-20001,''G'');',
'    end if; ',
'',
'end;',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'&P10_SMW_FEHLER.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(236664560298969108)
,p_internal_uid=>71758856264886450
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(236675118852969127)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Dialog schliessen'
,p_attribute_02=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(236664560298969108)
,p_process_when_type=>'NOT_DISPLAYING_INLINE_VALIDATION_ERRORS'
,p_internal_uid=>71759257762886451
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(234346102172913731)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Daten laden'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'    ',
'   l_query      varchar2(4000); ',
'',
'begin',
'',
'',
'',
'    APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(',
'        p_collection_name => ''SMW_OBJEKTE'');',
'',
'/*',
'    APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY_B (',
'        p_collection_name => ''A1_NC_NA_ADRESSEN'', ',
'        p_query => ''select haus_lfd_nr , firma, rw, hw  FROM strav.V_A1_NC_NA_ADRESSEN'',',
'        p_generate_md5 => ''NO'');',
'        */',
'',
'     begin ',
'            APEX_COLLECTION.DELETE_COLLECTION(',
'        p_collection_name => ''A1_NC_NA_ADRESSEN'');',
'    exception',
'        when others then ',
'        null;',
'     end;   ',
'',
'l_query := ''select haus_lfd_nr , firma, rw, hw  FROM strav.A1_NC_NA_ADRESSEN_TMP'';',
'',
'--    APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY_B (',
'--        p_collection_name => ''A1_NC_NA_ADRESSEN'', ',
'--        p_query => l_query);',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>69430241082831055
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(234346036437913730)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_OBJEKT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'-- ret varchar2(200);',
'begin',
'--raise_application_error (-20010,''Fehler !'' || :P2000_NORTH || '' '' || :P2000_SOUTH || '' '' || :P2000_EAST || '' '' || :P2000_WEST ||   sqlerrm);',
'for item in (',
'    select ncna.hw',
'       || '';'' || ncna.rw || '';''',
'       || ''OBJK'' ',
'       || '';'' ',
'       || ncna.haus_lfd_nr ',
'       || '';''  ',
'       --|| ''('' || pck_ftth.f_get_haus_typ (:P0_HAUS_LFD_NR) || '')'' ',
'        || s.STR_NAME46 || '' '' || h.HAUS_HNR || lower(HAUS_HNR_ZUS) || '', '' || p.plz_plz || '' '' || p.plz_oname',
'       || '';''  ',
'               as ret ',
'    from ( ',
'SELECT ncna.hw',
'       ,ncna.rw',
'       ,ncna.haus_lfd_nr ',
'        ',
'  FROM strav.V_A1_NC_NA_ADRESSEN ncna',
'   WHERE  ',
'   --NOT EXISTS  (SELECT 1 FROM dslam d INNER JOIN adresse adr ON d.STO_LFD_NR = adr.STO_LFD_NR WHERE adr.haus_lfd_nr = ncna.haus_lfd_nr)',
'',
'   --AND ',
'   ncna.HW BETWEEN replace(:P10_SOUTH,''.'','','') AND replace(:P10_NORTH,''.'','','')',
'   AND ncna.RW BETWEEN replace(:P10_WEST,''.'','','') AND replace(:P10_EAST,''.'','','') ',
'  -- AND :P0_SST_TYP = ''FTTB''',
'/*',
'UNION ALL',
'   SELECT ncna.hw',
'       ,ncna.rw',
'       ,ncna.haus_lfd_nr ',
'        ',
'  FROM strav.V_A1_NC_NA_ADRESSEN ncna',
'       INNER JOIN strav.haus h on ncna.haus_lfd_nr = h.haus_lfd_nr',
'   WHERE  1=1',
'   AND h.HAUS_WE_GES BETWEEN 1 AND 3',
'   AND ncna.HW BETWEEN replace(:P10_SOUTH,''.'','','') AND replace(:P10_NORTH,''.'','','')',
'   AND ncna.RW BETWEEN replace(:P10_WEST,''.'','','') AND replace(:P10_EAST,''.'','','') ',
'   AND :P0_SST_TYP IN( ''FTTH'',''GPON'')',
'*/',
'',
'',
'    ) ncna',
'',
'       inner join strav.haus h on ncna.haus_lfd_nr = h.haus_lfd_nr',
'       inner join strav.stra_db s on h.str_lfd_nr = s.str_lfd_nr',
'       inner join strav.plz_da p on s.str_plz = p.plz_plz and s.str_alort = p.plz_alort',
'',
'',
')',
'loop',
'      htp.prn(to_char(item.ret));  ',
'      --raise_application_error (-20010,''Fehler !'' || :P2000_NORTH || '' '' || :P2000_SOUTH || '' '' || :P2000_EAST || '' '' || :P2000_WEST ||   sqlerrm);',
'  end loop; ',
'  ',
'exception',
'when others then ',
'    ',
'    raise_application_error (-20010,''Fehler !'' || :P10_NORTH || '' '' || :P10_SOUTH || sqlerrm);',
'',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>69430175347831054
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(234346369375913733)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_OBJEKT_COLLECTION'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'-- ret varchar2(200);',
'begin',
'--raise_application_error (-20010,''Fehler !'' || :P2000_NORTH || '' '' || :P2000_SOUTH || '' '' || :P2000_EAST || '' '' || :P2000_WEST ||   sqlerrm);',
'for item in (',
'    select ncna.hw',
'       || '';'' || ncna.rw || '';''',
'       || ''OBJK'' ',
'       || '';'' ',
'       || ncna.haus_lfd_nr ',
'       || '';''  ',
'       --|| ''('' || pck_ftth.f_get_haus_typ (:P0_HAUS_LFD_NR) || '')'' ',
'        || s.STR_NAME46 || '' '' || h.HAUS_HNR || lower(HAUS_HNR_ZUS) || '', '' || p.plz_plz || '' '' || p.plz_oname',
'       || '';''  ',
'               as ret ',
'    from ( ',
'SELECT ncna.hw hw',
'       ,ncna.rw rw',
'       ,ncna.haus_lfd_nr haus_lfd_nr ',
'        ',
'  FROM strav.A1_NC_NA_ADRESSEN_TMP ncna',
'   WHERE  ',
'      ',
'   --NOT EXISTS  (SELECT 1 FROM dslam d INNER JOIN adresse adr ON d.STO_LFD_NR = adr.STO_LFD_NR WHERE adr.haus_lfd_nr = ncna.haus_lfd_nr)',
'',
'   --AND ',
'   ncna.hw BETWEEN replace(:P10_SOUTH,''.'','','') AND replace(:P10_NORTH,''.'','','')',
'   AND ncna.rw BETWEEN replace(:P10_WEST,''.'','','') AND replace(:P10_EAST,''.'','','') ',
'   and ncna.haus_lfd_nr not in ( select c001 from apex_collections where collection_name = ''SMW_OBJEKTE'')',
'  -- AND :P0_SST_TYP = ''FTTB''',
'/*',
'UNION ALL',
'   SELECT ncna.hw',
'       ,ncna.rw',
'       ,ncna.haus_lfd_nr ',
'        ',
'  FROM strav.V_A1_NC_NA_ADRESSEN ncna',
'       INNER JOIN strav.haus h on ncna.haus_lfd_nr = h.haus_lfd_nr',
'   WHERE  1=1',
'   AND h.HAUS_WE_GES BETWEEN 1 AND 3',
'   AND ncna.HW BETWEEN replace(:P10_SOUTH,''.'','','') AND replace(:P10_NORTH,''.'','','')',
'   AND ncna.RW BETWEEN replace(:P10_WEST,''.'','','') AND replace(:P10_EAST,''.'','','') ',
'   AND :P0_SST_TYP IN( ''FTTH'',''GPON'')',
'*/',
'',
'',
'    ) ncna',
'',
'       inner join strav.haus h on ncna.haus_lfd_nr = h.haus_lfd_nr',
'       inner join strav.stra_db s on h.str_lfd_nr = s.str_lfd_nr',
'       inner join strav.plz_da p on s.str_plz = p.plz_plz and s.str_alort = p.plz_alort',
'',
'',
')',
'loop',
'      htp.prn(to_char(item.ret));  ',
'      --raise_application_error (-20010,''Fehler !'' || :P2000_NORTH || '' '' || :P2000_SOUTH || '' '' || :P2000_EAST || '' '' || :P2000_WEST ||   sqlerrm);',
'  end loop; ',
'  ',
'exception',
'when others then ',
'    ',
'    raise_application_error (-20010,''Fehler !'' || :P10_NORTH || '' '' || :P10_SOUTH || sqlerrm);',
'',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>69430508285831057
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(234346467551913734)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_OBJEKT_STRAV'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'-- ret varchar2(200);',
'begin',
'--raise_application_error (-20010,''Fehler !'' || :P2000_NORTH || '' '' || :P2000_SOUTH || '' '' || :P2000_EAST || '' '' || :P2000_WEST ||   sqlerrm);',
'for item in (',
'    select umts2lat(px=> replace(haus_x_koord,''.'','',''), py=> replace(haus_y_koord,''.'','',''),pzone=> 32) ',
'       || '';'' ||umts2lon(px=> replace(haus_x_koord,''.'','',''), py=> replace(haus_y_koord,''.'','',''),pzone=> 32)  || '';''',
'       || ''OBJK'' ',
'       || '';'' ',
'       || h.haus_lfd_nr ',
'       || '';''  ',
'       --|| ''('' || pck_ftth.f_get_haus_typ (:P0_HAUS_LFD_NR) || '')'' ',
'        || s.STR_NAME46 || '' '' || h.HAUS_HNR || lower(HAUS_HNR_ZUS) || '', '' || p.plz_plz || '' '' || p.plz_oname',
'       || '';''  ',
'               as ret ',
'    from ',
'',
'        strav.haus h ',
'       inner join strav.stra_db s on h.str_lfd_nr = s.str_lfd_nr',
'       inner join strav.plz_da p on s.str_plz = p.plz_plz and s.str_alort = p.plz_alort',
'  where umts2lat(px=> replace(haus_x_koord,''.'','',''), py=> replace(haus_y_koord,''.'','',''),pzone=> 32)  BETWEEN replace(:P10_SOUTH,''.'','','') AND replace(:P10_NORTH,''.'','','')',
'     AND umts2lon(px=> replace(haus_x_koord,''.'','',''), py=> replace(haus_y_koord,''.'','',''),pzone=> 32)  BETWEEN replace(:P10_WEST,''.'','','') AND replace(:P10_EAST,''.'','','') ',
'',
')',
'loop',
'      htp.prn(to_char(item.ret));  ',
'      --raise_application_error (-20010,''Fehler !'' || :P2000_NORTH || '' '' || :P2000_SOUTH || '' '' || :P2000_EAST || '' '' || :P2000_WEST ||   sqlerrm);',
'  end loop; ',
'  ',
'exception',
'when others then ',
'    ',
'    raise_application_error (-20010,''Fehler !'' || :P10_NORTH || '' '' || :P10_SOUTH || sqlerrm);',
'',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>69430606461831058
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(238197797425208051)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_VERMARKTUNGSCLUSTER'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'declare',
'-- ret varchar2(200);',
'begin',
'--raise_application_error (-20010,''Fehler !'' || :P2000_NORTH || '' '' || :P2000_SOUTH || '' '' || :P2000_EAST || '' '' || :P2000_WEST ||   sqlerrm);',
'for item in (',
'    select ncna.hw',
'       || '';'' ||ncna.rw || '';''',
'       || ''VERMARKTUNGSCLUSTER'' ',
'       || '';'' ',
'       || h.haus_lfd_nr ',
'       || '';''  ',
'       --|| ''('' || pck_ftth.f_get_haus_typ (:P0_HAUS_LFD_NR) || '')'' ',
'        || s.STR_NAME46 || '' '' || h.HAUS_HNR || lower(HAUS_HNR_ZUS) || '', '' || p.plz_plz || '' '' || p.plz_oname',
'       || '';''  ',
'               as ret ',
'    from ',
'        VERMARKTUNGSCLUSTER_OBJEKT vco',
'        inner join strav.haus h on h.haus_lfd_nr = vco.haus_lfd_nr ',
'       inner join strav.stra_db s on h.str_lfd_nr = s.str_lfd_nr',
'       inner join strav.plz_da p on s.str_plz = p.plz_plz and s.str_alort = p.plz_alort',
'       inner join strav.V_A1_NC_NA_ADRESSEN ncna on ncna.haus_lfd_nr = h.haus_lfd_nr',
'--  where umts2lat(px=> replace(haus_x_koord,''.'','',''), py=> replace(haus_y_koord,''.'','',''),pzone=> 32)  BETWEEN replace(:P10_SOUTH,''.'','','') AND replace(:P10_NORTH,''.'','','')',
'--     AND umts2lon(px=> replace(haus_x_koord,''.'','',''), py=> replace(haus_y_koord,''.'','',''),pzone=> 32)  BETWEEN replace(:P10_WEST,''.'','','') AND replace(:P10_EAST,''.'','','') ',
'        where vco.vc_lfd_nr = apex_application.g_x01',
')',
'loop',
'      htp.prn(to_char(item.ret));  ',
'      --raise_application_error (-20010,''Fehler !'' || :P2000_NORTH || '' '' || :P2000_SOUTH || '' '' || :P2000_EAST || '' '' || :P2000_WEST ||   sqlerrm);',
'  end loop; ',
'  ',
'exception',
'when others then ',
'    ',
'    raise_application_error (-20010,''Fehler !'' || :P10_NORTH || '' '' || :P10_SOUTH || sqlerrm);',
'',
'end;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>73281936335125375
);
wwv_flow_imp.component_end;
end;
/
