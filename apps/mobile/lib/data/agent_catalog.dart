import 'package:flutter/material.dart';

import '../models/agent_profile.dart';

const agentCatalog = <AgentProfile>[
  AgentProfile(
      name: 'Amara',
      title: 'AI Business Development Manager',
      category: 'Sales & Business Development',
      description:
          'Finds prospects, researches companies, identifies decision-makers, generates leads, and manages follow-ups.',
      capabilities: [
        'Prospecting',
        'Company Research',
        'Decision-Maker ID',
        'Outreach'
      ],
      icon: Icons.trending_up_rounded),
  AgentProfile(
      name: 'Sarah',
      title: 'AI Sales Representative',
      category: 'Sales & Business Development',
      description:
          'Qualifies leads, answers product questions, prepares quotations, and helps close sales.',
      capabilities: [
        'Lead Qualification',
        'Quotations',
        'Follow-up',
        'Closing'
      ],
      icon: Icons.show_chart_rounded),
  AgentProfile(
      name: 'Jordan',
      title: 'AI Social Media Manager',
      category: 'Marketing & Content',
      description:
          'Plans content, writes posts, builds content calendars, and analyzes social performance.',
      capabilities: [
        'Content Calendar',
        'Copywriting',
        'Campaigns',
        'Analytics'
      ],
      icon: Icons.phone_iphone_rounded),
  AgentProfile(
      name: 'Maya',
      title: 'AI Content Writer',
      category: 'Marketing & Content',
      description:
          'Writes blogs, articles, website content, newsletters, and marketing copy.',
      capabilities: ['Blogging', 'Newsletters', 'Ad Copy', 'Proposals'],
      icon: Icons.edit_note_rounded),
  AgentProfile(
      name: 'Elena',
      title: 'AI Research Analyst',
      category: 'Marketing & Content',
      description:
          'Researches markets, competitors, and industries, and produces structured reports.',
      capabilities: ['Market Research', 'Competitor Analysis', 'Reporting'],
      icon: Icons.manage_search_rounded),
  AgentProfile(
      name: 'Farah',
      title: 'AI Tender & Proposal Specialist',
      category: 'Sales & Business Development',
      description:
          'Finds tenders, analyzes RFPs, builds compliance matrices, and drafts proposals on deadline.',
      capabilities: ['RFP Analysis', 'Compliance Matrix', 'Proposal Drafting'],
      icon: Icons.assignment_rounded),
  AgentProfile(
      name: 'Deka',
      title: 'AI HR Manager',
      category: 'People & Finance',
      description:
          'Creates job descriptions, screens and ranks applicants, and supports onboarding.',
      capabilities: [
        'Job Descriptions',
        'CV Screening',
        'Interview Prep',
        'Onboarding'
      ],
      icon: Icons.groups_rounded),
  AgentProfile(
      name: 'Kevin',
      title: 'AI Finance Assistant',
      category: 'People & Finance',
      description:
          'Tracks expenses, prepares invoices, organizes financial data, and generates basic reports.',
      capabilities: ['Expense Tracking', 'Invoicing', 'Reporting'],
      icon: Icons.payments_rounded),
  AgentProfile(
      name: 'Zara',
      title: 'AI Customer Support Agent',
      category: 'Customer & Executive Support',
      description:
          'Answers customers, troubleshoots common problems, and manages support tickets.',
      capabilities: ['Troubleshooting', 'Ticketing', 'Escalation'],
      icon: Icons.headset_mic_rounded),
  AgentProfile(
      name: 'Grace',
      title: 'AI Executive Assistant',
      category: 'Customer & Executive Support',
      description:
          'Manages schedules, meetings, reminders, emails, tasks, and daily briefings.',
      capabilities: ['Scheduling', 'Inbox Triage', 'Briefings'],
      icon: Icons.calendar_month_rounded),
  AgentProfile(
      name: 'Nadia',
      title: 'AI Teacher / Tutor',
      category: 'Education',
      description:
          'Builds a personalized curriculum, teaches step-by-step, sets homework, and adapts difficulty automatically.',
      capabilities: [
        'Curriculum Design',
        'Lesson Delivery',
        'Homework & Grading',
        'Progress Tracking'
      ],
      icon: Icons.school_rounded),
  AgentProfile(
      name: 'Layla',
      title: 'AI Language Teacher',
      category: 'Education',
      description:
          'Teaches languages through conversation, vocabulary, grammar, and pronunciation exercises.',
      capabilities: ['Conversation Practice', 'Grammar', 'Pronunciation'],
      icon: Icons.record_voice_over_rounded),
  AgentProfile(
      name: 'Marcus',
      title: 'AI Software Developer',
      category: 'Engineering & Design',
      description:
          'Builds and debugs software, writes code, and helps design and develop applications.',
      capabilities: ['Coding', 'Debugging', 'APIs'],
      icon: Icons.code_rounded),
  AgentProfile(
      name: 'Leo',
      title: 'AI Graphic Designer',
      category: 'Engineering & Design',
      description:
          'Creates brand concepts, marketing visuals, social-media designs, and presentations.',
      capabilities: ['Brand Concepts', 'Social Visuals', 'Presentations'],
      icon: Icons.palette_outlined),
  AgentProfile(
      name: 'Victor',
      title: 'AI Legal Assistant',
      category: 'Legal & Compliance',
      description:
          'Researches laws, summarizes contracts, and organizes legal documents.',
      capabilities: [
        'Contract Review',
        'Clause Identification',
        'Legal Research'
      ],
      icon: Icons.balance_rounded,
      note: 'Not a substitute for a licensed lawyer.'),
  AgentProfile(
      name: 'Naima',
      title: 'AI Medical Administrative Assistant',
      category: 'Healthcare Administration',
      description:
          'Organizes appointments, summarizes non-diagnostic information, and prepares administrative documents.',
      capabilities: ['Appointments', 'Admin Documents', 'General Info'],
      icon: Icons.local_hospital_outlined,
      note: 'Directs medical decisions to qualified professionals.'),
  AgentProfile(
      name: 'Priya',
      title: 'AI E-commerce Manager',
      category: 'Commerce & Data',
      description:
          'Manages product listings, customer questions, inventory info, and sales analysis.',
      capabilities: ['Listings', 'Inventory', 'Promotions'],
      icon: Icons.shopping_cart_outlined),
  AgentProfile(
      name: 'Daniel',
      title: 'AI Project Manager',
      category: 'Operations & Projects',
      description:
          'Breaks projects into tasks, monitors deadlines, and flags potential delays.',
      capabilities: ['Task Breakdown', 'Deadlines', 'Progress Reports'],
      icon: Icons.assignment_turned_in_outlined),
  AgentProfile(
      name: 'Chen',
      title: 'AI Data Analyst',
      category: 'Commerce & Data',
      description:
          'Analyzes spreadsheets and datasets, identifies trends, and explains insights in plain language.',
      capabilities: ['Spreadsheets', 'Trend Analysis', 'Insights'],
      icon: Icons.bar_chart_rounded),
  AgentProfile(
      name: 'Aisha',
      title: 'AI Marketing Manager',
      category: 'Marketing & Content',
      description:
          'Develops marketing strategies, customer personas, campaigns, and performance reports.',
      capabilities: ['Strategy', 'Personas', 'Budgets'],
      icon: Icons.campaign_outlined),
  AgentProfile(
      name: 'Ryan',
      title: 'AI IT Support Specialist',
      category: 'Engineering & Design',
      description:
          'Diagnoses common technical problems and guides users through fixes.',
      capabilities: ['Troubleshooting', 'Documentation', 'Software & Hardware'],
      icon: Icons.computer_rounded),
  AgentProfile(
      name: 'Fatima',
      title: 'AI Resume & Career Coach',
      category: 'Career & Lifestyle',
      description:
          'Improves CVs, writes cover letters, and prepares candidates for interviews.',
      capabilities: ['CV Writing', 'Cover Letters', 'Interview Prep'],
      icon: Icons.description_outlined),
  AgentProfile(
      name: 'Noah',
      title: 'AI Travel Planner',
      category: 'Career & Lifestyle',
      description:
          'Researches destinations, builds itineraries, and compares travel options.',
      capabilities: ['Itineraries', 'Comparisons', 'Scheduling'],
      icon: Icons.travel_explore_rounded),
  AgentProfile(
      name: 'Halima',
      title: 'AI Operations Manager',
      category: 'Operations & Projects',
      description:
          'Creates SOPs, organizes workflows, and identifies ways to improve efficiency.',
      capabilities: ['SOPs', 'Workflows', 'Efficiency'],
      icon: Icons.settings_suggest_outlined),
  AgentProfile(
      name: 'Sam',
      title: 'AI Personal Productivity Coach',
      category: 'Career & Lifestyle',
      description:
          'Helps set goals, prioritize tasks, build routines, and track progress.',
      capabilities: ['Goal Setting', 'Prioritization', 'Accountability'],
      icon: Icons.psychology_outlined),
];
