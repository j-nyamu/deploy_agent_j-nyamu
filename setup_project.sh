#!/bin/bash

# ============================================
# Automated Project Bootstrapping Script
# Student Attendance Tracker Deployment
# Author: j-nyamu
# ============================================

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Global variable
PROJECT_DIR=""

# ============================================
# SIGNAL TRAP FUNCTION
# ============================================
cleanup_on_interrupt() {
    echo -e "\n${YELLOW}⚠️  Interrupt signal received (Ctrl+C)${NC}"
    echo -e "${BLUE}📦 Archiving incomplete project...${NC}"
    
    if [ -d "$PROJECT_DIR" ]; then
        ARCHIVE_NAME="${PROJECT_DIR}_archive.tar.gz"
        tar -czf "$ARCHIVE_NAME" "$PROJECT_DIR" 2>/dev/null
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Archive created: $ARCHIVE_NAME${NC}"
        else
            echo -e "${RED}✗ Failed to create archive${NC}"
        fi
        
        rm -rf "$PROJECT_DIR"
        echo -e "${GREEN}✓ Incomplete directory cleaned up${NC}"
    fi
    
    echo -e "${YELLOW}Exiting...${NC}"
    exit 130
}

trap cleanup_on_interrupt SIGINT

# ============================================
# ENVIRONMENT VALIDATION
# ============================================
validate_environment() {
    echo -e "${BLUE}🔍 Validating environment...${NC}"
    
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version)
        echo -e "${GREEN}✓ Python3 is installed: $PYTHON_VERSION${NC}"
        return 0
    else
        echo -e "${RED}✗ WARNING: Python3 is not installed!${NC}"
        echo -e "${YELLOW}  The application requires Python3 to run.${NC}"
        return 1
    fi
}

# ============================================
# DIRECTORY CREATION
# ============================================
create_directory_structure() {
    local project_name=$1
    PROJECT_DIR="attendance_tracker_${project_name}"
    
    echo -e "${BLUE}📁 Creating project directory: $PROJECT_DIR${NC}"
    
    if [ -d "$PROJECT_DIR" ]; then
        echo -e "${YELLOW}⚠️  Directory '$PROJECT_DIR' already exists!${NC}"
        read -p "Do you want to overwrite it? (yes/no): " overwrite
        if [[ "$overwrite" != "yes" ]]; then
            echo -e "${RED}✗ Setup cancelled${NC}"
            exit 1
        fi
        rm -rf "$PROJECT_DIR"
    fi
    
    mkdir -p "$PROJECT_DIR"
    mkdir -p "$PROJECT_DIR/Helpers"
    mkdir -p "$PROJECT_DIR/reports"
    
    echo -e "${GREEN}✓ Directory structure created${NC}"
}

# ============================================
# FILE DEPLOYMENT
# ============================================
deploy_files() {
    echo -e "${BLUE}📄 Deploying application files...${NC}"
    
    if [ ! -f "attendance_checker.py" ] || [ ! -f "config.json" ] || [ ! -f "assets.csv" ] || [ ! -f "reports.log" ]; then
        echo -e "${RED}✗ Error: Source files not found${NC}"
        echo -e "${YELLOW}  Required: attendance_checker.py, config.json, assets.csv, reports.log${NC}"
        exit 1
    fi
    
    cp attendance_checker.py "$PROJECT_DIR/"
    cp config.json "$PROJECT_DIR/Helpers/"
    cp assets.csv "$PROJECT_DIR/Helpers/"
    cp reports.log "$PROJECT_DIR/reports/"
    
    chmod +x "$PROJECT_DIR/attendance_checker.py"
    
    echo -e "${GREEN}✓ Files deployed successfully${NC}"
}

# ============================================
# CONFIGURATION UPDATE (USING SED)
# ============================================
update_configuration() {
    echo -e "\n${BLUE}⚙️  Configuration Setup${NC}"
    read -p "Do you want to update attendance thresholds? (yes/no): " update_config
    
    if [[ "$update_config" == "yes" ]]; then
        while true; do
            read -p "Enter Warning Threshold percentage (default 75): " warning_threshold
            warning_threshold=${warning_threshold:-75}
            
            if [[ "$warning_threshold" =~ ^[0-9]+$ ]] && [ "$warning_threshold" -ge 0 ] && [ "$warning_threshold" -le 100 ]; then
                break
            else
                echo -e "${RED}✗ Invalid. Enter a number between 0-100${NC}"
            fi
        done
        
        while true; do
            read -p "Enter Failure Threshold percentage (default 50): " failure_threshold
            failure_threshold=${failure_threshold:-50}
            
            if [[ "$failure_threshold" =~ ^[0-9]+$ ]] && [ "$failure_threshold" -ge 0 ] && [ "$failure_threshold" -le 100 ]; then
                break
            else
                echo -e "${RED}✗ Invalid. Enter a number between 0-100${NC}"
            fi
        done
        
        CONFIG_FILE="$PROJECT_DIR/Helpers/config.json"
        sed -i "s/\"warning\": [0-9]*/\"warning\": $warning_threshold/" "$CONFIG_FILE"
        sed -i "s/\"failure\": [0-9]*/\"failure\": $failure_threshold/" "$CONFIG_FILE"
        
        echo -e "${GREEN}✓ Configuration updated: Warning=${warning_threshold}%, Failure=${failure_threshold}%${NC}"
    else
        echo -e "${YELLOW}Using default thresholds: Warning=75%, Failure=50%${NC}"
    fi
}

# ============================================
# VERIFICATION
# ============================================
verify_structure() {
    echo -e "\n${BLUE}🔍 Verifying project structure...${NC}"
    
    local all_good=true
    
    local required_files=(
        "$PROJECT_DIR/attendance_checker.py"
        "$PROJECT_DIR/Helpers/config.json"
        "$PROJECT_DIR/Helpers/assets.csv"
        "$PROJECT_DIR/reports/reports.log"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            echo -e "${GREEN}✓ Found: $file${NC}"
        else
            echo -e "${RED}✗ Missing: $file${NC}"
            all_good=false
        fi
    done
    
    if [ "$all_good" = true ]; then
        echo -e "\n${GREEN}========================================${NC}"
        echo -e "${GREEN}✓ Project setup completed successfully!${NC}"
        echo -e "${GREEN}========================================${NC}"
        return 0
    else
        echo -e "\n${RED}✗ Setup verification failed${NC}"
        return 1
    fi
}

# ============================================
# MAIN EXECUTION
# ============================================
main() {
    echo -e "${GREEN}========================================${NC}"
    echo -e "${GREEN}  Student Attendance Tracker Setup${NC}"
    echo -e "${GREEN}  Automated Project Bootstrapping${NC}"
    echo -e "${GREEN}========================================${NC}\n"
    
    read -p "Enter project identifier (e.g., 'spring2024', 'cohort5'): " project_id
    
    if [ -z "$project_id" ]; then
        echo -e "${RED}✗ Project identifier cannot be empty${NC}"
        exit 1
    fi
    
    create_directory_structure "$project_id"
    deploy_files
    update_configuration
    validate_environment
    verify_structure
    
    echo -e "\n${BLUE}📋 Next Steps:${NC}"
    echo -e "   1. Navigate: ${GREEN}cd $PROJECT_DIR${NC}"
    echo -e "   2. Run: ${GREEN}python3 attendance_checker.py${NC}"
    echo -e "   3. View: ${GREEN}cat reports/reports.log${NC}"
    echo -e "\n${YELLOW}💡 Tip: Press Ctrl+C during setup to trigger cleanup and archiving${NC}\n"
}

main
