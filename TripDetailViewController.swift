//
//  TripDetailViewController.swift
//  itinerary_app
//
//  Created by yuxin on 8/7/25.
//

import UIKit

class TripDetailViewController: UIViewController {
    
    private var trip: Trip
    private let tripManager = TripManager.shared
    private let tableView = UITableView()
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshTrip()
    }
    
    private func refreshTrip() {
        if let updatedTrip = tripManager.getTrip(by: trip.id) {
            self.trip = updatedTrip
            tableView.reloadData()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "ActivityCell")
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: "HeaderCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = trip.title
        
        let addButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(addActivityTapped)
        )
        addButton.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addActivityTapped() {
        let createActivityVC = CreateActivityViewController(tripId: trip.id)
        createActivityVC.delegate = self
        let navController = UINavigationController(rootViewController: createActivityVC)
        present(navController, animated: true)
    }
    
    private func showDeleteActivityConfirmation(for indexPath: IndexPath) {
        let activity = trip.activities[indexPath.row - 1] // -1 for header
        
        let alert = UIAlertController(
            title: "Delete Activity",
            message: "Are you sure you want to delete '\(activity.title)'?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.tripManager.deleteActivity(from: self.trip.id, at: indexPath.row - 1)
            self.refreshTrip()
        })
        
        present(alert, animated: true)
    }
    
    private func editActivity(at indexPath: IndexPath) {
        let activity = trip.activities[indexPath.row - 1] // -1 for header
        let editActivityVC = CreateActivityViewController(tripId: trip.id, activity: activity, activityIndex: indexPath.row - 1)
        editActivityVC.delegate = self
        let navController = UINavigationController(rootViewController: editActivityVC)
        present(navController, animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension TripDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trip.activities.count + 1 // +1 for header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // Header cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderTableViewCell
            cell.configure(with: trip)
            return cell
        } else {
            // Activity cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath) as! ActivityTableViewCell
            let activity = trip.activities[indexPath.row - 1]
            cell.configure(with: activity)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row > 0 {
            editActivity(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row > 0 // Don't allow editing header
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.row > 0 {
            showDeleteActivityConfirmation(for: indexPath)
        }
    }
}

// MARK: - CreateActivityDelegate
extension TripDetailViewController: CreateActivityDelegate {
    func didCreateActivity() {
        refreshTrip()
    }
    
    func didUpdateActivity() {
        refreshTrip()
    }
}

// MARK: - Header Table View Cell
class HeaderTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let activitiesCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container view
        containerView.backgroundColor = .systemBlue
        containerView.layer.cornerRadius = 16
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .white
        
        // Date label
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = .white.withAlphaComponent(0.9)
        
        // Activities count label
        activitiesCountLabel.font = UIFont.systemFont(ofSize: 12)
        activitiesCountLabel.textColor = .white.withAlphaComponent(0.8)
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(activitiesCountLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        activitiesCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            activitiesCountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            activitiesCountLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            activitiesCountLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            activitiesCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with trip: Trip) {
        titleLabel.text = trip.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "\(formatter.string(from: trip.startDate)) - \(formatter.string(from: trip.endDate))"
        
        let activityCount = trip.activities.count
        activitiesCountLabel.text = "\(activityCount) \(activityCount == 1 ? "activity" : "activities") planned"
    }
}

// MARK: - Activity Table View Cell
class ActivityTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let durationLabel = UILabel()
    private let lineView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Container view
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1)
        containerView.layer.shadowRadius = 2
        containerView.layer.shadowOpacity = 0.1
        
        // Time label
        timeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        timeLabel.textColor = .label
        timeLabel.textAlignment = .center
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 12
        iconImageView.backgroundColor = .systemOrange.withAlphaComponent(0.2)
        iconImageView.tintColor = .systemOrange
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .label
        
        // Location label
        locationLabel.font = UIFont.systemFont(ofSize: 14)
        locationLabel.textColor = .secondaryLabel
        
        // Duration label
        durationLabel.font = UIFont.systemFont(ofSize: 12)
        durationLabel.textColor = .tertiaryLabel
        
        // Line view for connection
        lineView.backgroundColor = .systemGray5
        
        contentView.addSubview(containerView)
        containerView.addSubview(timeLabel)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(locationLabel)
        containerView.addSubview(durationLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            timeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 60),
            
            iconImageView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 12),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            
            durationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            durationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            durationLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 2),
            durationLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with activity: Activity) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: activity.time)
        
        iconImageView.image = UIImage(systemName: activity.type.icon)
        titleLabel.text = activity.title
        locationLabel.text = activity.location
        
        if let duration = activity.duration, !duration.isEmpty {
            durationLabel.text = "Duration: \(duration)"
            durationLabel.isHidden = false
        } else {
            durationLabel.isHidden = true
        }
        
        // Set color based on activity type
        switch activity.type {
        case .transport:
            iconImageView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
            iconImageView.tintColor = .systemOrange
        case .accommodation:
            iconImageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
            iconImageView.tintColor = .systemBlue
        case .activity:
            iconImageView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.2)
            iconImageView.tintColor = .systemGreen
        case .food:
            iconImageView.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
            iconImageView.tintColor = .systemRed
        case .other:
            iconImageView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
            iconImageView.tintColor = .systemGray
        }
    }
}
