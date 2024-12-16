#!/bin/bash

# Alternatives for parameters:
# SOUND:  
#   0 - Default interior sound
#   1 - Muted sound
#   2 - Enhanced sound
#   3 - Surround sound
#
# DMG:
#   0 - No damage
#   1 - Default damage
#   2 - High damage
#   3 - Extreme damage
#
# LOD:
#   0 - Minimum drawing distance (low-end PC)
#   1 - Reduced drawing distance
#   2 - Standard drawing distance (average PC)
#   3 - Maximum drawing distance (high-end PC)

# Variables for parameters
GAME="ets" #"ats"
SOUND="0"           # Default interior sound
DMG="1"             # Default damage
LOD="2"             # Standard drawing distance (average PC)
COL_ROAD="707070"   # Silver - DEFAULT SETTING
COL_DROAD="ffc64c"  # Gold - DEFAULT SETTING
COL_OUT="000000"    # Black - DEFAULT SETTING
COL_NAVI="cf0c0c"   # Red - DEFAULT SETTING
COL_ARROW="11fb06"  # Green - DEFAULT SETTING
COL_JOB="353535"    # Grey - DEFAULT SETTING
COL_DJOB="36342b"   # Charcoal - DEFAULT SETTING
COL_MAP="707070"    # Silver - DEFAULT SETTING
COL_DMAP="707070"   # Silver - DEFAULT SETTING

# Perform POST request
curl -X POST "https://example.com/gendef.php" \
     -H "Content-Type: application/x-www-form-urlencoded" \
     --data-urlencode "sound=$SOUND" \
     --data-urlencode "dmg=$DMG" \
     --data-urlencode "lod=$LOD" \
     --data-urlencode "col_road=$COL_ROAD" \
     --data-urlencode "col_droad=$COL_DROAD" \
     --data-urlencode "col_out=$COL_OUT" \
     --data-urlencode "col_navi=$COL_NAVI" \
     --data-urlencode "col_arrow=$COL_ARROW" \
     --data-urlencode "col_job=$COL_JOB" \
     --data-urlencode "col_djob=$COL_DJOB" \
     --data-urlencode "col_map=$COL_MAP" \
     --data-urlencode "col_dmap=$COL_DMAP"


# Function to prompt user input and return a value
prompt_user() {
  local prompt="$1"
  local default="$2"
  read -p "$prompt [$default]: " input
  echo "${input:-$default}"
}

# Function to configure POST parameters
configure_params() {
  local params=("${!1}")
  local final_params=()

  # Ask if the user wants to use defaults
  use_defaults=$(prompt_user "Use defaults for all parameters? (y/n)" "y")
  if [[ "$use_defaults" == "y" ]]; then
    final_params=("${params[@]}")
    echo "${final_params[@]}"
    return
  fi

  # Customize parameters step-by-step
  for param in "${params[@]}"; do
    key="${param%%=*}"
    value="${param#*=}"
    new_value=$(prompt_user "Set value for $key" "$value")
    final_params+=("$key=$new_value")
  done

  echo "${final_params[@]}"
}

# Function to send POST request
send_post_request() {
  local url="$1"
  local params=("${!2}")
  echo "Sending POST request to $url with parameters:"
  for param in "${params[@]}"; do
    echo "  - $param"
  done

  # Send the POST request using curl
  curl -X POST "$url" -d "$(IFS=&; echo "${params[*]}")"
}

# Main menu for location selection
echo "Choose your location:"
echo "1 - America"
echo "2 - Europe"
read -p "Enter your choice (1/2): " choice

if [[ "$choice" == "1" ]]; then
  selected_params=("${AMERICA_PARAMS[@]}")
elif [[ "$choice" == "2" ]]; then
  selected_params=("${EUROPE_PARAMS[@]}")
else
  echo "Invalid choice."
  exit 1
fi

# Configure parameters based on user input
final_params=($(configure_params selected_params[@]))

# Send the POST request
send_post_request "$GENDEF_URL" final_params[@]
