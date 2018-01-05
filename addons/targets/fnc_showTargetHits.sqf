#include "script_component.hpp"

params [
    ["_show", true, [false]],
    ["_impactTracers", false, [false]],
    ["_viewRange", DEFAULT_VIEWRANGE, [0]]
];

GVAR(showTargetHits) = _show;
GVAR(impactTracers) = _impactTracers;
GVAR(targetViewRange) = _viewRange;
