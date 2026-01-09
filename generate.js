const fs = require('fs');

// Existing data
let data = {
  "startDate": "2026-01-01",
  "followersByDay": {
    "2026-01-01": 0,
    "2026-01-02": 10,
    "2026-01-03": 1000
  }
};

// Generate dates from 2026-01-04 to 2026-01-09
let start = new Date('2026-01-04');
let end = new Date('2026-01-09');
let dates = [];
for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
  dates.push(d.toISOString().split('T')[0]);
}

// Generate unique random numbers between 0 and 1000000
let used = new Set([0, 10, 1000]); // existing values
let followers = [];
for (let i = 0; i < dates.length; i++) {
  let num;
  do {
    num = Math.floor(Math.random() * 1000001);
  } while (used.has(num));
  used.add(num);
  followers.push(num);
}

// Add to data
dates.forEach((date, i) => {
  data.followersByDay[date] = followers[i];
});

// Write back
fs.writeFileSync('data.json', JSON.stringify(data, null, 2));