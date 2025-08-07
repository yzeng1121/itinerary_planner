//
//  TripListViewController.swift
//  itinerary_app
//
//  Created by yuxin on 8/7/25.
//
import UIKit

class TripsListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let tripManager = TripManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemGroupedBackground
        
        // Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: "TripCell")
        
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
        title = "My Trips"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTripTapped)
        )
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func addTripTapped() {
        let createTripVC = CreateTripViewController()
        createTripVC.delegate = self
        let navController = UINavigationController(rootViewController: createTripVC)
        present(navController, animated: true)
    }
    
    private func showDeleteConfirmation(for indexPath: IndexPath) {
        let trip = tripManager.trips[indexPath.row]
        
        let alert = UIAlertController(
            title: "Delete Trip",
            message: "Are you sure you want to delete '\(trip.title)'?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.tripManager.deleteTrip(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension TripsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripManager.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripTableViewCell
        let trip = tripManager.trips[indexPath.row]
        cell.configure(with: trip)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trip = tripManager.trips[indexPath.row]
        let detailVC = TripDetailViewController(trip: trip)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteConfirmation(for: indexPath)
        }
    }
}

// MARK: - CreateTripDelegate
extension TripsListViewController: CreateTripDelegate {
    func didCreateTrip(_ trip: Trip) {
        tripManager.addTrip(trip)
        tableView.reloadData()
    }
}

// MARK: - Trip Table View Cell
class TripTableViewCell: UITableViewCell {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let activitiesLabel = UILabel()
    private let chevronImageView = UIImageView()
    
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
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        
        // Date label
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        dateLabel.textColor = .systemBlue
        
        // Activities label
        activitiesLabel.font = UIFont.systemFont(ofSize: 12)
        activitiesLabel.textColor = .secondaryLabel
        
        // Chevron
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .systemGray3
        chevronImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(activitiesLabel)
        containerView.addSubview(chevronImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        activitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            activitiesLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            activitiesLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            activitiesLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            activitiesLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16),
            
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func configure(with trip: Trip) {
        titleLabel.text = trip.title
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        dateLabel.text = "\(formatter.string(from: trip.startDate)) - \(formatter.string(from: trip.endDate))"
        
        let activityCount = trip.activities.count
        activitiesLabel.text = "\(activityCount) \(activityCount == 1 ? "activity" : "activities")"
    }
}
