# Student Attendance Tracker - Automated Setup Script

**Made by:** Junior Nyamu  
**GitHub:** https://github.com/j-nyamu/deploy_agent_j-nyamu

---

## What Does This Do?

Instead of manually creating folders and copying files every time you want to set up this attendance tracker app, I built a script that does it all automatically. You just run one command, answer a few questions, and boom - everything is set up and ready to go.

---

## What's Inside This Project?

- **setup_project.sh** - The magic script that does all the work
- **attendance_checker.py** - The actual Python app that checks student attendance
- **config.json** - Settings file (what percentage is passing vs failing)
- **assets.csv** - Sample student data
- **reports.log** - Where the app writes its results

---

## Cool Features

### It Creates Everything Automatically
When you run the script, it creates a complete project folder with all the right subfolders (Helpers/ and reports/) and puts all the files where they need to be.

### You Can Customize the Thresholds
The script asks if you want to change what counts as "warning" or "failing" attendance. If you say yes, it lets you type in your own numbers and automatically updates the config file for you (using a command called `sed`).

### It Has Your Back if You Mess Up
If you accidentally press Ctrl+C in the middle of setup, the script doesn't just crash and leave a mess. Instead, it:
1. Saves everything you did so far into a zip file
2. Deletes the incomplete folder so your workspace stays clean
3. Exits gracefully

Pretty cool, right?

### It Checks if Python is Installed
Before finishing, the script makes sure you have Python3 installed. If you don't, it warns you that the app won't work without it.

---

## How to Use This

### First Time Setup:
```bash
git clone https://github.com/j-nyamu/deploy_agent_j-nyamu.git
cd deploy_agent_j-nyamu
chmod +x setup_project.sh
./setup_project.sh
```

### What Happens Next:
1. It asks you to name your project (like "spring2024" or whatever)
2. It asks if you want to change the attendance thresholds
   - If you say **yes**: type in your numbers (like 80% for warning, 60% for failure)
   - If you say **no**: it uses the defaults (75% warning, 50% failure)
3. It creates everything and tells you when it's done

### Running the App:
After setup completes, go into your new folder and run the Python app:
```bash
cd attendance_tracker_[whatever_you_named_it]
python3 attendance_checker.py
cat reports/reports.log
```

---

## The Ctrl+C Safety Feature

### What is This?
If you start running the setup script but then realize you made a mistake or want to stop, just press **Ctrl+C**.

### What Happens:
Instead of leaving a half-finished mess in your folder, the script:
- Packages everything it created so far into a `.tar.gz` file (like a zip)
- Deletes the incomplete folder
- Says goodbye nicely

### Example:
```bash
$ ./setup_project.sh
Enter project identifier: oops_wrong_name
[Oh no! Press Ctrl+C]

  Interrupt signal received (Ctrl+C)
  Archiving incomplete project...
✓ Archive created: attendance_tracker_oops_wrong_name_archive.tar.gz
✓ Incomplete directory cleaned up
Exiting...
```

Now you can run it again with the correct name, and your workspace is still clean.

---

## How the Config File Works

The app uses a JSON file to store settings:
```json
{
  "thresholds": {
    "warning": 75,
    "failure": 50
  },
  "run_mode": "live",
  "total_sessions": 15
}
```

**In English:**
- If a student's attendance is below 50%, they're failing
- If it's between 50% and 75%, they get a warning
- Above 75%, they're good

When you run the script and change these numbers, it uses a command called    `sed` to automatically edit this file. You don't have to open it manually.

---

## What I Learned Making This

- How to write shell scripts that actually do useful things
- How to catch Ctrl+C so programs don't just crash
- How to automatically edit files from the command line (using `sed`)
- How to validate user input so people can't break the script by typing garbage
- How to use Git properly and push my work to GitHub

---

## Video Walkthrough

This will be linked in the submission of this project

---

## About Me

I'm Junior Nyamu, a software engineering student at African Leadership University. This project was for our Systems Programming lab where we learned automation and scripting.

Check out the code: https://github.com/j-nyamu 

on GitHub

---

## Questions?

If something doesn't work or you're confused about anything, open an issue on GitHub or check the code. It's all there and I tried to add comments to explain what's happening.

Good luck! 
